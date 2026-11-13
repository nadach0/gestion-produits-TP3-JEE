<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>${empty produit.id ? 'Nouveau produit' : 'Modifier le produit'}</title>
</head>
<body>
    <h1>${empty produit.id ? 'Nouveau produit' : 'Modifier le produit'}</h1>

    <form method="post" action="${ctx}/produits">
        <c:if test="${not empty produit.id}">
            <input type="hidden" name="id" value="${produit.id}">
        </c:if>

        <div>
            <label>Nom * :</label><br>
            <input type="text" name="nom" value="<c:out value='${produit.nom}'/>">
            <c:if test="${not empty erreurs.nom}">
                <div style="color: red;"><c:out value="${erreurs.nom}" /></div>
            </c:if>
        </div><br>

        <div>
            <label>Description :</label><br>
            <textarea name="description" rows="3" cols="40"><c:out value="${produit.description}" /></textarea>
            <c:if test="${not empty erreurs.description}">
                <div style="color: red;"><c:out value="${erreurs.description}" /></div>
            </c:if>
        </div><br>

        <div>
            <label>Prix * :</label><br>
            <input type="text" name="prix" value="<c:out value='${produit.prix}'/>">
            <c:if test="${not empty erreurs.prix}">
                <div style="color: red;"><c:out value="${erreurs.prix}" /></div>
            </c:if>
        </div><br>

        <div>
            <label>Stock :</label><br>
            <input type="number" name="stock" value="<c:out value='${produit.stock}'/>">
            <c:if test="${not empty erreurs.stock}">
                <div style="color: red;"><c:out value="${erreurs.stock}" /></div>
            </c:if>
        </div><br>

        <button type="submit">Enregistrer</button>
        <a href="${ctx}/produits">Annuler</a>
    </form>
</body>
</html>