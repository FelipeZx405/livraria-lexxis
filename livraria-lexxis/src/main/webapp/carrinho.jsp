<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setLocale value="pt_BR"/>
<c:set var="logado" value="${not empty sessionScope.usuarioLogado}"/>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Carrinho - Livraria Lexxis</title>

    <link rel="stylesheet" href="/css/style.css">

    <style>
        :root {
            --marrom: #5a2d0c;
            --marrom-escuro: #3f1e08;
            --cinza-fundo: #d9d9d9;
            --cinza-borda: #cfcfcf;
            --texto: #1f1f1f;
            --texto-suave: #666;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background: #fff;
            color: var(--texto);
            font-size: 14px;
            line-height: 1.4;
        }

        a {
            color: inherit;
        }

        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 0 20px 40px;
        }

        /* ---------- Titulo ---------- */
        .caminho {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 20px 0 14px;
            color: var(--texto-suave);
        }

        .caminho svg {
            width: 16px;
            height: 16px;
            fill: var(--texto-suave);
        }

        .caminho a {
            text-decoration: none;
        }

        h1 {
            font-size: 26px;
        }

        .subtitulo {
            font-size: 12px;
            font-weight: bold;
            color: var(--texto-suave);
            margin: 4px 0 18px;
        }

        .mensagem {
            background: #fff3cd;
            border: 1px solid #ffe08a;
            border-radius: 6px;
            padding: 10px 14px;
            margin-bottom: 16px;
            font-size: 13px;
        }

        /* ---------- Layout ---------- */
        .layout {
            display: grid;
            grid-template-columns: 1fr 320px;
            gap: 24px;
            align-items: start;
        }

        .lista {
            background: #fff;
            border: 1px solid var(--cinza-borda);
            border-radius: 8px;
            padding: 16px;
        }

        .item {
            display: grid;
            grid-template-columns: 88px 1fr auto;
            align-items: center;
            gap: 16px;
            background: var(--cinza-fundo);
            border-radius: 6px;
            padding: 12px;
            margin-bottom: 14px;
        }

        .foto {
            width: 88px;
            height: 88px;
            background: #9a9a9a;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .foto svg {
            width: 44px;
            height: 44px;
            fill: #6f6f6f;
        }

        .nome {
            font-weight: bold;
            font-size: 14px;
        }

        .autor {
            font-size: 12px;
            color: var(--texto-suave);
        }

        .preco-unit {
            font-size: 11px;
            margin-top: 6px;
        }

        .aviso-estoque {
            display: inline-block;
            margin-top: 4px;
            font-size: 11px;
            font-weight: bold;
            color: #9a3412;
        }

        .acoes {
            display: flex;
            align-items: center;
            gap: 18px;
        }

        .qtd {
            display: flex;
            align-items: center;
            background: #b9b9b9;
            border-radius: 6px;
            overflow: hidden;
        }

        .qtd form {
            display: flex;
        }

        .qtd-btn {
            width: 32px;
            height: 32px;
            border: 0;
            background: transparent;
            font-size: 18px;
            color: var(--texto);
            cursor: pointer;
        }

        .qtd-btn:hover:not(:disabled) {
            background: #a5a5a5;
        }

        .qtd-btn:disabled {
            opacity: .35;
            cursor: not-allowed;
        }

        .qtd-valor {
            min-width: 32px;
            text-align: center;
            font-weight: bold;
        }

        .subtotal {
            font-weight: bold;
            min-width: 84px;
            text-align: right;
        }

        .lixeira {
            border: 0;
            background: transparent;
            padding: 6px;
            border-radius: 6px;
            display: flex;
            cursor: pointer;
        }

        .lixeira svg {
            width: 22px;
            height: 22px;
            fill: #555;
        }

        .lixeira:hover {
            background: #c9c9c9;
        }

        .lixeira:hover svg {
            fill: #b42318;
        }

        .rodape-lista {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 12px;
        }

        .link-seta {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            text-decoration: none;
        }

        .link-seta svg {
            width: 14px;
            height: 14px;
            fill: currentColor;
        }

        .link-seta:hover {
            text-decoration: underline;
        }

        .btn-texto {
            background: none;
            border: 0;
            font-size: 12px;
            color: var(--texto-suave);
            text-decoration: underline;
            cursor: pointer;
        }

        /* ---------- Resumo ---------- */
        .resumo {
            background: #e6e6e6;
            border: 1px solid var(--cinza-borda);
            border-radius: 8px;
            padding: 18px;
            position: sticky;
            top: 16px;
        }

        .resumo h2 {
            font-size: 16px;
            padding-bottom: 10px;
            border-bottom: 1px solid #999;
            margin-bottom: 8px;
        }

        .linha {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
        }

        .linha.total {
            border-top: 1px solid #999;
            font-size: 16px;
            font-weight: bold;
            margin: 6px 0 16px;
            padding-top: 14px;
        }

        .btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            width: 100%;
            padding: 12px;
            border-radius: 6px;
            border: 1px solid transparent;
            font-size: 14px;
            font-weight: bold;
            text-decoration: none;
            cursor: pointer;
        }

        .btn svg {
            width: 16px;
            height: 16px;
            fill: currentColor;
        }

        .btn-marrom {
            background: var(--marrom);
            color: #fff;
        }

        .btn-marrom:hover:not(:disabled) {
            background: var(--marrom-escuro);
        }

        .btn-marrom:disabled {
            opacity: .65;
            cursor: not-allowed;
        }

        .btn-contorno {
            background: transparent;
            border-color: #666;
            color: var(--texto);
            margin-top: 10px;
        }

        .btn-contorno:hover {
            background: #d6d6d6;
        }

        .nota {
            font-size: 11px;
            color: var(--texto-suave);
            text-align: center;
            margin-top: 8px;
        }

        .nota a {
            font-weight: bold;
        }

        /* ---------- Carrinho vazio ---------- */
        .vazio {
            text-align: center;
            padding: 48px 16px;
            background: #fff;
            border: 1px solid var(--cinza-borda);
            border-radius: 8px;
        }

        .vazio svg {
            width: 56px;
            height: 56px;
            fill: #9a9a9a;
            margin-bottom: 12px;
        }

        .vazio h2 {
            margin-bottom: 6px;
        }

        .vazio p {
            color: var(--texto-suave);
            margin-bottom: 18px;
        }

        .vazio .btn {
            display: inline-flex;
            width: auto;
            padding: 12px 24px;
        }

        /* ---------- Celular ---------- */
        @media (max-width: 860px) {
            .layout {
                grid-template-columns: 1fr;
            }

            .resumo {
                position: static;
            }
        }

        @media (max-width: 560px) {
            .item {
                grid-template-columns: 72px 1fr;
            }

            .foto {
                width: 72px;
                height: 72px;
            }

            .acoes {
                grid-column: 1 / -1;
                justify-content: space-between;
            }
        }
    </style>
</head>
<body>

<%@ include file="/WEB-INF/menu.jspf" %>

<div class="container">

    <!-- ================= TITULO ================= -->
    <div class="caminho">
        <a href="/catalogo" aria-label="Início">
            <svg viewBox="0 0 24 24"><path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/></svg>
        </a>
        <span>/</span>
        <span>Carrinho</span>
    </div>

    <h1>Meu Carrinho</h1>
    <p class="subtitulo">Revise seus itens antes de finalizar a compra.</p>

    <c:if test="${not empty mensagem}">
        <p class="mensagem"><c:out value="${mensagem}"/></p>
    </c:if>

    <c:choose>

        <%-- ================= CARRINHO VAZIO ================= --%>
        <c:when test="${carrinho.vazio}">
            <div class="vazio">
                <svg viewBox="0 0 24 24"><path d="M7 18c-1.1 0-1.99.9-1.99 2S5.9 22 7 22s2-.9 2-2-.9-2-2-2zM1 2v2h2l3.6 7.59-1.35 2.45c-.16.28-.25.61-.25.96 0 1.1.9 2 2 2h12v-2H7.42c-.14 0-.25-.11-.25-.25l.03-.12.9-1.63h7.45c.75 0 1.41-.41 1.75-1.03l3.58-6.49A1.003 1.003 0 0 0 20 4H5.21l-.94-2H1zm16 16c-1.1 0-1.99.9-1.99 2s.89 2 1.99 2 2-.9 2-2-.9-2-2-2z"/></svg>
                <h2>Seu carrinho está vazio</h2>
                <p>Que tal descobrir novos mundos através da leitura?</p>
                <a class="btn btn-marrom" href="/catalogo">Ver catálogo</a>
            </div>
        </c:when>

        <%-- ================= CARRINHO COM ITENS ================= --%>
        <c:otherwise>
            <div class="layout">

                <!-- ---------- Lista de itens ---------- -->
                <section class="lista">

                    <c:forEach var="item" items="${carrinho.itens}">
                        <article class="item">

                            <div class="foto">
                                <svg viewBox="0 0 24 24"><path d="M21 19V5c0-1.1-.9-2-2-2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2zM8.5 13.5l2.5 3.01L14.5 12l4.5 6H5l3.5-4.5z"/></svg>
                            </div>

                            <div class="info">
                                <p class="nome"><c:out value="${item.livro.nome}"/></p>
                                <p class="autor"><c:out value="${item.livro.autor}"/></p>
                                <p class="preco-unit">
                                    <fmt:formatNumber value="${item.livro.preco}" type="currency"/>
                                </p>
                                <c:if test="${item.livro.estoque <= 3}">
                                    <span class="aviso-estoque">Restam ${item.livro.estoque} unidade(s)</span>
                                </c:if>
                            </div>

                            <div class="acoes">

                                <!-- Quantidade: - 1 + -->
                                <div class="qtd">
                                    <form action="/carrinho" method="post">
                                        <input type="hidden" name="acao" value="atualizar">
                                        <input type="hidden" name="id" value="${item.livro.id}">
                                        <input type="hidden" name="quantidade" value="${item.quantidade - 1}">
                                        <button type="submit" class="qtd-btn" aria-label="Diminuir quantidade"
                                                ${item.quantidade <= 1 ? 'disabled' : ''}>&minus;</button>
                                    </form>

                                    <span class="qtd-valor">${item.quantidade}</span>

                                    <form action="/carrinho" method="post">
                                        <input type="hidden" name="acao" value="atualizar">
                                        <input type="hidden" name="id" value="${item.livro.id}">
                                        <input type="hidden" name="quantidade" value="${item.quantidade + 1}">
                                        <button type="submit" class="qtd-btn" aria-label="Aumentar quantidade"
                                                ${item.quantidade >= item.livro.estoque ? 'disabled' : ''}>+</button>
                                    </form>
                                </div>

                                <!-- Subtotal do item -->
                                <span class="subtotal">
                                    <fmt:formatNumber value="${item.subtotal}" type="currency"/>
                                </span>

                                <!-- Lixeira -->
                                <form action="/carrinho" method="post">
                                    <input type="hidden" name="acao" value="remover">
                                    <input type="hidden" name="id" value="${item.livro.id}">
                                    <button type="submit" class="lixeira" aria-label="Remover item" title="Remover item">
                                        <svg viewBox="0 0 24 24"><path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/></svg>
                                    </button>
                                </form>

                            </div>
                        </article>
                    </c:forEach>

                    <div class="rodape-lista">
                        <a class="link-seta" href="/catalogo">
                            <svg viewBox="0 0 24 24"><path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/></svg>
                            Continuar comprando
                        </a>

                        <form action="/carrinho" method="post">
                            <input type="hidden" name="acao" value="limpar">
                            <button type="submit" class="btn-texto">Esvaziar carrinho</button>
                        </form>
                    </div>

                </section>

                <!-- ---------- Resumo do pedido ---------- -->
                <aside class="resumo">
                    <h2>Resumo do Pedido</h2>

                    <div class="linha">
                        <span>Subtotal (${carrinho.quantidadeTotal} ${carrinho.quantidadeTotal == 1 ? 'item' : 'itens'})</span>
                        <span><fmt:formatNumber value="${carrinho.total}" type="currency"/></span>
                    </div>

                    <div class="linha total">
                        <span>Total</span>
                        <span><fmt:formatNumber value="${carrinho.total}" type="currency"/></span>
                    </div>

                    <!--
                        A finalizacao da compra ainda nao existe.
                        Quando existir, troque este <button> por:
                        <a class="btn btn-marrom" href="/finalizar-compra">Finalizar Compra</a>
                    -->
                    <button type="button" class="btn btn-marrom" disabled>
                        <svg viewBox="0 0 24 24"><path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2z"/></svg>
                        Finalizar Compra
                    </button>

                    <c:choose>
                        <c:when test="${logado}">
                            <p class="nota">A finalização da compra será liberada em breve.</p>
                        </c:when>
                        <c:otherwise>
                            <p class="nota"><a href="/login">Entre na sua conta</a> para finalizar a compra.</p>
                        </c:otherwise>
                    </c:choose>

                    <a class="btn btn-contorno" href="/catalogo">
                        <svg viewBox="0 0 24 24"><path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"/></svg>
                        Voltar às compras
                    </a>
                </aside>

            </div>
        </c:otherwise>

    </c:choose>

</div>

<%@ include file="/WEB-INF/rodape.jspf" %>

</body>
</html>