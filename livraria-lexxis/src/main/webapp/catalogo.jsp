<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setLocale value="pt_BR"/>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Catálogo - Livraria Lexxis</title>
</head>
<body>
<h1>Catálogo de Livros</h1>

<p>
    <a href="/carrinho">
        Ver carrinho (<c:out value="${empty sessionScope.carrinho ? 0 : sessionScope.carrinho.quantidadeTotal}"/>)
    </a>
</p>

<table border="1">
    <tr>
        <th>Livro</th>
        <th>Autor</th>
        <th>Preço</th>
        <th>Estoque</th>
        <th>Comprar</th>
    </tr>
    <c:forEach var="livro" items="${livros}">
        <tr>
            <td><c:out value="${livro.nome}"/></td>
            <td><c:out value="${livro.autor}"/></td>
            <td><fmt:formatNumber value="${livro.preco}" type="currency"/></td>
            <td>${livro.estoque}</td>
            <td>
                <c:choose>
                    <c:when test="${livro.estoque > 0}">
                        <form action="/carrinho" method="post">
                            <input type="hidden" name="acao" value="adicionar">
                            <input type="hidden" name="id" value="${livro.id}">
                            <input type="number" name="quantidade" value="1" min="1" max="${livro.estoque}">
                            <button type="submit">Adicionar ao carrinho</button>
                        </form>
                    </c:when>
                    <c:otherwise>Esgotado</c:otherwise>
                </c:choose>
            </td>
        </tr>
    </c:forEach>
</table>

</body>
</html>