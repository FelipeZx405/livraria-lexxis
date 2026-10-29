<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setLocale value="pt_BR"/>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Carrinho - Livraria Lexxis</title>
</head>
<body>
<h1>Carrinho de Compras</h1>

<c:if test="${not empty mensagem}">
    <p><strong><c:out value="${mensagem}"/></strong></p>
</c:if>

<c:choose>

    <c:when test="${carrinho.vazio}">
        <p>Seu carrinho está vazio.</p>
    </c:when>

    <c:otherwise>
        <table border="1">
            <tr>
                <th>Livro</th>
                <th>Autor</th>
                <th>Preço</th>
                <th>Quantidade</th>
                <th>Subtotal</th>
                <th>Remover</th>
            </tr>

            <c:forEach var="item" items="${carrinho.itens}">
                <tr>
                    <td><c:out value="${item.livro.nome}"/></td>
                    <td><c:out value="${item.livro.autor}"/></td>
                    <td><fmt:formatNumber value="${item.livro.preco}" type="currency"/></td>
                    <td>
                        <form action="/carrinho" method="post">
                            <input type="hidden" name="acao" value="atualizar">
                            <input type="hidden" name="id" value="${item.livro.id}">
                            <input type="number" name="quantidade" value="${item.quantidade}"
                                   min="0" max="${item.livro.estoque}">
                            <button type="submit">Atualizar</button>
                        </form>
                    </td>
                    <td><fmt:formatNumber value="${item.subtotal}" type="currency"/></td>
                    <td>
                        <form action="/carrinho" method="post">
                            <input type="hidden" name="acao" value="remover">
                            <input type="hidden" name="id" value="${item.livro.id}">
                            <button type="submit">Remover</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </table>

        <h3>Total: <fmt:formatNumber value="${carrinho.total}" type="currency"/></h3>

        <form action="/carrinho" method="post">
            <input type="hidden" name="acao" value="limpar">
            <button type="submit">Esvaziar carrinho</button>
        </form>
    </c:otherwise>

</c:choose>

<p><a href="/catalogo">Continuar comprando</a></p>

</body>
</html>