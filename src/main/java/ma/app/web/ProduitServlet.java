package ma.app.web;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import ma.app.model.Produit;
import ma.app.model.ProduitDAO;

@WebServlet("/produits")
public class ProduitServlet extends HttpServlet {
    private ProduitDAO dao;

    @Override
    public void init() {
        dao = (ProduitDAO) getServletContext().getAttribute("produitDAO");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("new".equals(action)) {
            req.setAttribute("produit", new Produit());
            req.getRequestDispatcher("/WEB-INF/views/produits/form.jsp").forward(req, resp);
            return;
        }

        if ("edit".equals(action)) {
            Long id = parseLong(req.getParameter("id"));
            Produit produit = dao.findById(id);
            if (produit == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            req.setAttribute("produit", produit);
            req.getRequestDispatcher("/WEB-INF/views/produits/form.jsp").forward(req, resp);
            return;
        }

        req.setAttribute("produits", dao.findAll());
        req.getRequestDispatcher("/WEB-INF/views/produits/list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("delete".equals(action)) {
            Long id = parseLong(req.getParameter("id"));
            Produit p = dao.findById(id);
            if (p != null) {
                dao.delete(id);
                req.getSession().setAttribute("flash", "Produit « " + p.getNom() + " » supprimé.");
            }
            resp.sendRedirect(req.getContextPath() + "/produits");
            return;
        }

        Long id = parseLong(req.getParameter("id"));
        String nom = req.getParameter("nom");
        String description = req.getParameter("description");
        String prixStr = req.getParameter("prix");
        String stockStr = req.getParameter("stock");

        Map<String, String> erreurs = new HashMap<>();

        if (nom == null || nom.trim().length() < 2 || nom.trim().length() > 50) {
            erreurs.put("nom", "Le nom est obligatoire (entre 2 et 50 caractères).");
        } else {
            nom = nom.trim();
        }

        if (description != null && description.length() > 255) {
            erreurs.put("description", "La description ne doit pas dépasser 255 caractères.");
        }

        BigDecimal prix = null;
        if (prixStr == null || prixStr.trim().isEmpty()) {
            erreurs.put("prix", "Le prix est obligatoire.");
        } else {
            try {
                prix = new BigDecimal(prixStr.trim().replace(",", "."));
                if (prix.compareTo(BigDecimal.ZERO) <= 0) {
                    erreurs.put("prix", "Le prix doit être strictement positif.");
                }
            } catch (NumberFormatException e) {
                erreurs.put("prix", "Format de prix invalide.");
            }
        }

        int stock = 0;
        if (stockStr != null && !stockStr.trim().isEmpty()) {
            try {
                stock = Integer.parseInt(stockStr.trim());
                if (stock < 0) {
                    erreurs.put("stock", "Le stock doit être supérieur ou égal à 0.");
                }
            } catch (NumberFormatException e) {
                erreurs.put("stock", "Le stock doit être un nombre entier.");
            }
        }

        Produit produit = new Produit(id, nom, description, prix, stock);

        if (!erreurs.isEmpty()) {
            req.setAttribute("erreurs", erreurs);
            req.setAttribute("produit", produit);
            req.getRequestDispatcher("/WEB-INF/views/produits/form.jsp").forward(req, resp);
            return;
        }

        dao.save(produit);
        req.getSession().setAttribute("flash", "Produit « " + produit.getNom() + " » enregistré.");
        resp.sendRedirect(req.getContextPath() + "/produits");
    }

    private Long parseLong(String val) {
        if (val == null || val.trim().isEmpty()) return null;
        try {
            return Long.parseLong(val.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
