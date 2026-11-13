<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Connexion</title>
</head>
<body>
    <h1>Connexion</h1>

    <c:if test="${not empty erreur}">
        <p style="color: red;"><c:out value="${erreur}" /></p>
    </c:if>

    <form method="post" action="${ctx}/login">
        <div>
            <label>Identifiant :</label>
            <input type="text" name="username" value="<c:out value='${username}'/>" required>
        </div><br>
        <div>
            <label>Mot de passe :</label>
            <input type="password" name="password" required>
        </div><br>
        <button type="submit">Se connecter</button>
    </form>
</body>
</html>