<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Livraria Lexxis - Livro</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
<%@ include file="/WEB-INF/menu.jspf" %>

<div class="conteudo-pagina">
    <h2>Livraria Lexxis</h2>
    <h3>${empty param.id ? 'Novo livro' : 'Editar livro'}</h3>

    <p><a href="/find-all-livros">&larr; Voltar para a lista de livros</a></p>

    <form action="/create-livro" method="post">

        <label>Nome do Livro:</label>
        <input type="text" name="name" id="name" value="<c:out value='${param.name}'/>">
        <input type="hidden" name="id" id="id" value="<c:out value='${param.id}'/>">

        <br><label>Autor:</label>
        <input type="text" name="autor" value="<c:out value='${param.autor}'/>">

        <br><label>Descricao:</label>
        <input type="text" name="descricao" value="<c:out value='${param.descricao}'/>">

        <br><label>Preco:</label>
        <input type="number" step="0.01" min="0" name="preco" value="<c:out value='${param.preco}'/>">
        <br>

        <br><label>Estoque:</label>
        <input type="number" min="0" step="1" name="estoque" value="<c:out value='${param.estoque}'/>">

        <button type="submit">Registrar</button>

    </form>
</div>

<%@ include file="/WEB-INF/rodape.jspf" %>
</body>
</html>