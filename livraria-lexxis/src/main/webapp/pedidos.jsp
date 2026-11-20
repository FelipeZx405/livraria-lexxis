<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setLocale value="pt_BR"/>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Meus pedidos - Livraria Lexxis</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/checkout.css">
</head>
<body>

<%@ include file="/WEB-INF/menu.jspf" %>

<div class="container">

    <div class="caminho">
        <a href="/home">Início</a>
        <span>/</span>
        <span>Meus pedidos</span>
    </div>

    <h1>Meus pedidos</h1>
    <p class="subtitulo">Acompanhe as suas compras na Livraria Lexxis.</p>

    <c:choose>

        <c:when test="${empty pedidos}">
            <div class="vazio">
                <h2>Você ainda não fez nenhum pedido</h2>
                <p>Quando você finalizar uma compra, ela aparece aqui.</p>
                <a class="btn btn-marrom" href="/catalogo">Ver catálogo</a>
            </div>
        </c:when>

        <c:otherwise>
            <section class="bloco">
                <div class="tabela-wrap">
                    <table class="tabela-pedidos">
                        <thead>
                        <tr>
                            <th>Pedido</th>
                            <th>Data</th>
                            <th>Itens</th>
                            <th>Pagamento</th>
                            <th>Situação</th>
                            <th class="num">Total</th>
                            <th></th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="p" items="${pedidos}">
                            <tr>
                                <td><strong>#${p.id}</strong></td>
                                <td><fmt:formatDate value="${p.data}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td>${p.quantidadeTotal}</td>
                                <td><c:out value="${p.formaDescricao}"/></td>
                                <td><span class="situacao s-${p.situacao}"><c:out value="${p.situacaoDescricao}"/></span></td>
                                <td class="num"><fmt:formatNumber value="${p.total}" type="currency"/></td>
                                <td class="num"><a class="btn btn-contorno btn-pequeno" href="/pedido?id=${p.id}">Detalhes</a></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </section>
        </c:otherwise>

    </c:choose>

</div>

<%@ include file="/WEB-INF/rodape.jspf" %>

</body>
</html>