<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Criar conta</title>
</head>
<body>
<h2>Livraria Lexxis - Criar conta</h2>

<c:if test="${not empty erro}">
    <p><b>${erro}</b></p>
</c:if>

<form action="/registro" method="post">

    <label>Nome:</label>
    <input type="text" name="nome" required value="<c:out value="${param.nome}"/>">

    <br><label>Email:</label>
    <input type="email" name="email" required value="<c:out value="${param.email}"/>">

    <br><label>Senha (mínimo 6 caracteres):</label>
    <input type="password" name="senha" required>

    <br><label>Confirmar senha:</label>
    <input type="password" name="confirmacao" required>

    <br>
    <button type="submit">Criar conta</button>

</form>

<p>Já tem conta? <a href="/login">Entrar</a></p>

</body>
</html>