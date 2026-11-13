<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Produits</title>
</head>
<body>
    <h1>Catalogue de produits</h1>

    <c:if test="${not empty sessionScope.flash}">
        <p style="color: green; font-weight: bold;"><c:out value="${sessionScope.flash}" /></p>
        <c:remove var="flash" scope="session" />
    </c:if>

    <p><a href="${ctx}/produits?action=new">Ajouter un produit</a></p>

    <c:choose>
        <c:when test="${empty produits}">
            <p>Aucun produit disponible.</p>
        </c:when>
        <c:otherwise>
            <table border="1" cellpadding="6" cellspacing="0">
                <thead>
                    <tr>
                        <th>Nom</th>
                        <th>Description</th>
                        <th>Prix</th>
                        <th>Stock</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${produits}">
                        <tr>
                            <td><c:out value="${p.nom}" /></td>
                            <td><c:out value="${p.description}" /></td>
                            <td><fmt:formatNumber value="${p.prix}" minFractionDigits="2" maxFractionDigits="2" /> DH</td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.stock == 0}">
                                        <span style="color: red; font-weight: bold;">0 (Rupture)</span>
                                    </c:when>
                                    <c:otherwise>
                                        ${p.stock}
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="${ctx}/produits?action=edit&id=${p.id}">Éditer</a>
                                <form method="post" action="${ctx}/produits?action=delete" style="display:inline;"
                                      onsubmit="return confirm('Supprimer ce produit ?');">
                                    <input type="hidden" name="id" value="${p.id}">
                                    <button type="submit">Supprimer</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>

    <p><a href="${ctx}/dashboard">Retour au tableau de bord</a></p>
</body>
</html>
