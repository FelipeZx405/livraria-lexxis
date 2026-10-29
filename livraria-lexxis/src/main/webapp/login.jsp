<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
</head>
<body>
<h2>Livraria Lexxis - Entrar</h2>

<c:if test="${param.registrado == '1'}">
    <p>Conta criada com sucesso! Faça login.</p>
</c:if>

<c:if test="${not empty erro}">
    <p><b>${erro}</b></p>
</c:if>

<form action="/login" method="post">

    <label>Email:</label>
    <input type="email" name="email" required>

    <br><label>Senha:</label>
    <input type="password" name="senha" required>

    <br>
    <button type="submit">Entrar</button>

</form>

<p>Não tem conta? <a href="/registro">Criar conta</a></p>

</body>
</html>