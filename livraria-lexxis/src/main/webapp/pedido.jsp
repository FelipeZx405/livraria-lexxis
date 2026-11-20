<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setLocale value="pt_BR"/>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Pedido ${pedido.id} - Livraria Lexxis</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/checkout.css">
</head>
<body>

<%@ include file="/WEB-INF/menu.jspf" %>

<div class="container">

    <div class="caminho">
        <a href="/home">Início</a>
        <span>/</span>
        <a href="/pedidos">Meus pedidos</a>
        <span>/</span>
        <span>Pedido #${pedido.id}</span>
    </div>

    <div class="titulo-linha">
        <h1>Pedido #${pedido.id}</h1>
        <span class="situacao s-${pedido.situacao}"><c:out value="${pedido.situacaoDescricao}"/></span>
    </div>
    <p class="subtitulo">Feito em <fmt:formatDate value="${pedido.data}" pattern="dd/MM/yyyy 'às' HH:mm"/></p>

    <c:if test="${param.novo == '1'}">
        <p class="msg ok">Pedido realizado com sucesso! Obrigado por comprar na Lexxis.</p>
    </c:if>
    <c:if test="${param.ok == 'pago'}">
        <p class="msg ok">Pagamento confirmado (simulação).</p>
    </c:if>
    <c:if test="${param.ok == 'cancelado'}">
        <p class="msg aviso">Pedido cancelado. Os livros voltaram ao estoque.</p>
    </c:if>

    <div class="layout-pedido">

        <!-- ================= COLUNA ESQUERDA ================= -->
        <div>

            <!-- ---------- Pagamento ---------- -->
            <section class="bloco">
                <h2>Pagamento</h2>

                <p>
                    <strong>Forma:</strong> <c:out value="${pedido.formaDescricao}"/>
                    <c:if test="${pedido.cartao}">
                        &mdash; cartão final <c:out value="${pedido.cartaoFinal}"/>,
                        ${pedido.parcelas}x de <fmt:formatNumber value="${pedido.valorParcela}" type="currency"/>
                    </c:if>
                </p>

                <c:choose>

                    <c:when test="${pedido.cancelado}">
                        <p class="msg aviso" style="margin-top:12px;">Este pedido foi cancelado.</p>
                    </c:when>

                    <c:when test="${pedido.pago}">
                        <p class="msg ok" style="margin-top:12px;">Pagamento confirmado.</p>
                    </c:when>

                    <c:when test="${pedido.pix}">
                        <p style="margin-top:12px;">Copie o código abaixo e pague no app do seu banco:</p>
                        <div class="codigo-box">
                            <code id="codigo-pix"><c:out value="${pedido.codigoPix}"/></code>
                            <button type="button" class="btn btn-contorno btn-pequeno" data-copiar="codigo-pix">Copiar</button>
                        </div>
                        <p class="nota" style="text-align:left;">Código de demonstração: não é um Pix real.</p>
                    </c:when>

                    <c:when test="${pedido.boleto}">
                        <p style="margin-top:12px;">
                            Pague até <strong><fmt:formatDate value="${pedido.vencimentoBoleto}" pattern="dd/MM/yyyy"/></strong>:
                        </p>
                        <div class="codigo-box">
                            <code id="codigo-boleto"><c:out value="${pedido.linhaDigitavel}"/></code>
                            <button type="button" class="btn btn-contorno btn-pequeno" data-copiar="codigo-boleto">Copiar</button>
                        </div>
                        <p class="nota" style="text-align:left;">Linha digitável de demonstração: não é um boleto real.</p>
                    </c:when>

                </c:choose>
            </section>

            <!-- ---------- Itens ---------- -->
            <section class="bloco">
                <h2>Itens do pedido</h2>

                <div class="tabela-wrap">
                    <table class="tabela-pedidos">
                        <thead>
                        <tr>
                            <th>Livro</th>
                            <th class="num">Preço</th>
                            <th class="num">Qtd.</th>
                            <th class="num">Subtotal</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="item" items="${pedido.itens}">
                            <tr>
                                <td>
                                    <strong><c:out value="${item.nome}"/></strong><br>
                                    <small><c:out value="${item.autor}"/></small>
                                </td>
                                <td class="num"><fmt:formatNumber value="${item.preco}" type="currency"/></td>
                                <td class="num">${item.quantidade}</td>
                                <td class="num"><fmt:formatNumber value="${item.subtotal}" type="currency"/></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </section>

            <!-- ---------- Entrega ---------- -->
            <section class="bloco">
                <h2>Entrega</h2>
                <p><strong><c:out value="${pedido.destNome}"/></strong></p>
                <p>
                    <c:out value="${pedido.endereco}"/>, <c:out value="${pedido.numero}"/>
                    <c:if test="${not empty pedido.complemento}"> - <c:out value="${pedido.complemento}"/></c:if>
                </p>
                <p><c:out value="${pedido.bairro}"/> - <c:out value="${pedido.cidade}"/>/<c:out value="${pedido.uf}"/></p>
                <p>CEP <c:out value="${pedido.cepFormatado}"/></p>
            </section>

        </div>

        <!-- ================= RESUMO ================= -->
        <aside class="resumo">
            <h2>Resumo</h2>

            <div class="linha">
                <span>Subtotal (${pedido.quantidadeTotal} ${pedido.quantidadeTotal == 1 ? 'item' : 'itens'})</span>
                <span><fmt:formatNumber value="${pedido.subtotal}" type="currency"/></span>
            </div>

            <div class="linha">
                <span>Frete</span>
                <span>
                    <c:choose>
                        <c:when test="${pedido.frete == 0}">Grátis</c:when>
                        <c:otherwise><fmt:formatNumber value="${pedido.frete}" type="currency"/></c:otherwise>
                    </c:choose>
                </span>
            </div>

            <c:if test="${pedido.desconto > 0}">
                <div class="linha desconto">
                    <span>Desconto Pix</span>
                    <span>- <fmt:formatNumber value="${pedido.desconto}" type="currency"/></span>
                </div>
            </c:if>

            <div class="linha total">
                <span>Total</span>
                <span><fmt:formatNumber value="${pedido.total}" type="currency"/></span>
            </div>

            <c:if test="${dono and pedido.aguardandoPagamento}">

                <form action="/pedido" method="post">
                    <input type="hidden" name="id" value="${pedido.id}">
                    <input type="hidden" name="acao" value="pagar">
                    <button type="submit" class="btn btn-marrom">Simular pagamento confirmado</button>
                </form>

                <form action="/pedido" method="post" onsubmit="return confirm('Cancelar este pedido?');">
                    <input type="hidden" name="id" value="${pedido.id}">
                    <input type="hidden" name="acao" value="cancelar">
                    <button type="submit" class="btn btn-perigo">Cancelar pedido</button>
                </form>

            </c:if>

            <a class="btn btn-contorno" href="/pedidos">Meus pedidos</a>
            <a class="btn btn-contorno" href="/catalogo">Continuar comprando</a>
        </aside>

    </div>

</div>

<%@ include file="/WEB-INF/rodape.jspf" %>

<script>
    (function () {

        var botoes = document.querySelectorAll('[data-copiar]');

        Array.prototype.forEach.call(botoes, function (botao) {

            botao.addEventListener('click', function () {

                var alvo = document.getElementById(botao.getAttribute('data-copiar'));
                var texto = alvo.textContent.replace(/^\s+|\s+$/g, '');

                function feito() {
                    botao.textContent = 'Copiado!';
                    setTimeout(function () { botao.textContent = 'Copiar'; }, 1800);
                }

                if (navigator.clipboard && navigator.clipboard.writeText) {
                    navigator.clipboard.writeText(texto).then(feito);
                    return;
                }

                var faixa = document.createRange();
                faixa.selectNodeContents(alvo);
                var selecao = window.getSelection();
                selecao.removeAllRanges();
                selecao.addRange(faixa);
                document.execCommand('copy');
                selecao.removeAllRanges();
                feito();
            });
        });

    })();
</script>

</body>
</html>