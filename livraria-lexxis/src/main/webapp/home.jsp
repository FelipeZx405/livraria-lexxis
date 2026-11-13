<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setLocale value="pt_BR"/>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Início - Livraria Lexxis</title>

    <link rel="stylesheet" href="/css/style.css">

    <style>
        :root {
            --marrom: #5a2d0c;
            --marrom-escuro: #3f1e08;
            --cinza-fundo: #d9d9d9;
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

        .home {
            max-width: 1040px;
            margin: 0 auto;
            padding: 0 20px 24px;
        }

        /* ---------- Banner ---------- */
        .home-hero {
            display: grid;
            grid-template-columns: 1.5fr 1fr;
            gap: 32px;
            align-items: center;
            background: var(--cinza-fundo);
            border-radius: 10px;
            padding: 36px;
        }

        .home-etiqueta {
            display: inline-block;
            margin-bottom: 14px;
            padding: 4px 12px;
            background: var(--marrom);
            border-radius: 12px;
            color: #fff;
            font-size: 11px;
            font-weight: bold;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .home-hero h1 {
            font-size: 32px;
            line-height: 1.15;
            margin-bottom: 12px;
        }

        .home-hero p {
            max-width: 460px;
            margin-bottom: 22px;
            font-size: 15px;
            color: #444;
        }

        .home-btn {
            display: inline-block;
            padding: 12px 26px;
            background: var(--marrom);
            border-radius: 6px;
            color: #fff;
            font-weight: bold;
            text-decoration: none;
        }

        .home-btn:hover {
            background: var(--marrom-escuro);
        }

        .home-hero-img {
            display: flex;
            align-items: center;
            justify-content: center;
            aspect-ratio: 1 / 1;
            overflow: hidden;
            background: #b5b5b5;
            border-radius: 8px;
        }

        .home-hero-img img {
            width: 100%;
            height: 100%;
            padding: 12px;
            object-fit: contain;
        }

        /* ---------- Secoes ---------- */
        .home-secao {
            margin-top: 36px;
        }

        .home-secao-topo {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 16px;
        }

        .home-secao h2 {
            font-size: 18px;
        }

        .home-secao h2::after {
            content: "";
            display: block;
            width: 48px;
            height: 3px;
            margin-top: 6px;
            background: var(--marrom);
            border-radius: 2px;
        }

        .home-ver-todos {
            font-size: 12px;
            font-weight: bold;
            text-decoration: none;
        }

        .home-ver-todos:hover {
            text-decoration: underline;
        }

        /* ---------- Proxima Sessao (atalhos) ---------- */
        .home-atalhos {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
        }

        .home-atalho {
            display: flex;
            flex-direction: column;
            gap: 4px;
            padding: 18px;
            background: var(--cinza-fundo);
            border-radius: 8px;
            text-decoration: none;
            transition: transform .15s, box-shadow .15s;
        }

        .home-atalho:hover,
        .home-categoria:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 14px rgba(0, 0, 0, .15);
        }

        .home-atalho.principal {
            background: var(--marrom);
            color: #fff;
        }

        .home-atalho svg {
            width: 28px;
            height: 28px;
            margin-bottom: 6px;
            fill: currentColor;
        }

        .home-atalho strong {
            font-size: 14px;
        }

        .home-atalho span {
            font-size: 12px;
            opacity: .8;
        }

        /* ---------- Categorias ---------- */
        .home-categorias {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            gap: 16px;
        }

        .home-categoria {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 4px;
            padding: 18px 10px;
            background: var(--cinza-fundo);
            border-radius: 8px;
            text-align: center;
            text-decoration: none;
            transition: transform .15s, box-shadow .15s;
        }

        .home-circulo {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 44px;
            height: 44px;
            margin-bottom: 6px;
            background: #f0e4d8;
            border-radius: 50%;
        }

        .home-circulo svg {
            width: 22px;
            height: 22px;
            fill: var(--marrom);
        }

        .home-categoria strong {
            font-size: 13px;
        }

        .home-categoria span {
            font-size: 11px;
            color: var(--texto-suave);
        }

        /* ---------- Livros em destaque ---------- */
        .home-destaques {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 22px;
        }

        .home-livro {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 6px;
            text-align: center;
        }

        .home-livro-link {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
            width: 100%;
            text-decoration: none;
        }

        .home-capa {
            width: 100%;
            padding: 14px;
            background: var(--cinza-fundo);
            border-radius: 10px;
            transition: transform .15s, box-shadow .15s;
        }

        .home-livro-link:hover .home-capa {
            transform: translateY(-3px);
            box-shadow: 0 6px 14px rgba(0, 0, 0, .15);
        }

        .home-capa div {
            display: flex;
            align-items: center;
            justify-content: center;
            aspect-ratio: 3 / 4;
            background: #b5b5b5;
            border-radius: 6px;
        }

        .home-capa svg {
            width: 44px;
            height: 44px;
            fill: #8d8d8d;
        }

        .home-livro h3 {
            font-size: 14px;
        }

        .home-autor {
            font-size: 12px;
            color: var(--texto-suave);
        }

        .home-preco {
            padding: 2px 12px;
            background: var(--cinza-fundo);
            border-radius: 10px;
            font-size: 12px;
            font-weight: bold;
        }

        .home-add {
            width: 100%;
            margin-top: 4px;
        }

        .home-add button {
            width: 100%;
            padding: 8px;
            background: var(--marrom);
            border: 0;
            border-radius: 6px;
            color: #fff;
            font-size: 12px;
            font-weight: bold;
            cursor: pointer;
        }

        .home-add button:hover {
            background: var(--marrom-escuro);
        }

        .home-vazio {
            padding: 32px 16px;
            background: #f4f4f4;
            border: 1px dashed #bbb;
            border-radius: 8px;
            color: var(--texto-suave);
            text-align: center;
        }

        /* ---------- Celular ---------- */
        @media (max-width: 820px) {
            .home-hero {
                grid-template-columns: 1fr;
                padding: 24px;
            }

            .home-hero-img {
                max-width: 280px;
            }

            .home-atalhos {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 480px) {
            .home-hero h1 {
                font-size: 26px;
            }
        }
    </style>
</head>
<body>

<%@ include file="/WEB-INF/menu.jspf" %>

<main class="home">

    <!-- ================= BANNER ================= -->
    <section class="home-hero">
        <div>
            <span class="home-etiqueta">Livraria Lexxis</span>
            <h1>Descubra novos mundos através da leitura</h1>
            <p>Pesquise, escolha e compre livros de diferentes categorias e gêneros, em uma interface simples e intuitiva.</p>
            <a class="home-btn" href="/catalogo">Ver catálogo</a>
        </div>

        <div class="home-hero-img">
            <img src="/img/livros-login.png" alt="Pilha de livros Lexxis" onerror="this.style.display='none'">
        </div>
    </section>

    <!-- ================= PROXIMA SESSAO (atalhos para o catalogo) ================= -->
    <section class="home-secao">
        <div class="home-secao-topo">
            <h2>Próxima Sessão</h2>
        </div>

        <div class="home-atalhos">

            <a class="home-atalho principal" href="/catalogo">
                <svg viewBox="0 0 24 24"><path d="M18 2H6c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zM6 4h5v8l-2.5-1.5L6 12V4z"/></svg>
                <strong>Todos os livros</strong>
                <span>${totalLivros} no catálogo</span>
            </a>

            <a class="home-atalho" href="/catalogo?ordem=menor">
                <svg viewBox="0 0 24 24"><path d="M21.41 11.58l-9-9C12.05 2.22 11.55 2 11 2H4c-1.1 0-2 .9-2 2v7c0 .55.22 1.05.59 1.42l9 9c.36.36.86.58 1.41.58.55 0 1.05-.22 1.41-.59l7-7c.37-.36.59-.86.59-1.41 0-.55-.23-1.06-.59-1.42zM5.5 7C4.67 7 4 6.33 4 5.5S4.67 4 5.5 4 7 4.67 7 5.5 6.33 7 5.5 7z"/></svg>
                <strong>Menor preço</strong>
                <span>Do mais barato ao mais caro</span>
            </a>

            <a class="home-atalho" href="/catalogo?estoque=1">
                <svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/></svg>
                <strong>Disponíveis agora</strong>
                <span>Somente com estoque</span>
            </a>

            <a class="home-atalho" href="/catalogo?ordem=nome">
                <svg viewBox="0 0 24 24"><path d="M3 18h6v-2H3v2zM3 6v2h18V6H3zm0 7h12v-2H3v2z"/></svg>
                <strong>Ordem alfabética</strong>
                <span>Do A ao Z</span>
            </a>

        </div>
    </section>

    <!-- ================= CATEGORIAS ================= -->
    <section class="home-secao">
        <div class="home-secao-topo">
            <h2>Categorias</h2>
        </div>

        <div class="home-categorias">

            <c:set var="n" value="${empty contagem['Romance'] ? 0 : contagem['Romance']}"/>
            <a class="home-categoria" href="/catalogo?categoria=Romance">
                <div class="home-circulo">
                    <svg viewBox="0 0 24 24"><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/></svg>
                </div>
                <strong>Romance</strong>
                <span>${n} ${n == 1 ? 'livro' : 'livros'}</span>
            </a>

            <c:set var="n" value="${empty contagem['Suspense'] ? 0 : contagem['Suspense']}"/>
            <a class="home-categoria" href="/catalogo?categoria=Suspense">
                <div class="home-circulo">
                    <svg viewBox="0 0 24 24"><path d="M15.5 14h-.79l-.28-.27A6.471 6.471 0 0 0 16 9.5 6.5 6.5 0 1 0 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/></svg>
                </div>
                <strong>Suspense</strong>
                <span>${n} ${n == 1 ? 'livro' : 'livros'}</span>
            </a>

            <c:set var="n" value="${empty contagem['Ficção Científica'] ? 0 : contagem['Ficção Científica']}"/>
            <a class="home-categoria" href="/catalogo?categoria=Fic%C3%A7%C3%A3o%20Cient%C3%ADfica">
                <div class="home-circulo">
                    <svg viewBox="0 0 24 24"><path d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zm4.24 16L12 15.45 7.77 18l1.12-4.81-3.73-3.23 4.92-.42L12 5l1.92 4.53 4.92.42-3.73 3.23L16.23 18z"/></svg>
                </div>
                <strong>Ficção Científica</strong>
                <span>${n} ${n == 1 ? 'livro' : 'livros'}</span>
            </a>

            <c:set var="n" value="${empty contagem['Comédia'] ? 0 : contagem['Comédia']}"/>
            <a class="home-categoria" href="/catalogo?categoria=Com%C3%A9dia">
                <div class="home-circulo">
                    <svg viewBox="0 0 24 24"><path d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zM12 20c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8zm3.5-9c.83 0 1.5-.67 1.5-1.5S16.33 8 15.5 8 14 8.67 14 9.5s.67 1.5 1.5 1.5zm-7 0c.83 0 1.5-.67 1.5-1.5S9.33 8 8.5 8 7 8.67 7 9.5 7.67 11 8.5 11zm3.5 6.5c2.33 0 4.31-1.46 5.11-3.5H6.89c.8 2.04 2.78 3.5 5.11 3.5z"/></svg>
                </div>
                <strong>Comédia</strong>
                <span>${n} ${n == 1 ? 'livro' : 'livros'}</span>
            </a>

            <c:set var="n" value="${empty contagem['Educação'] ? 0 : contagem['Educação']}"/>
            <a class="home-categoria" href="/catalogo?categoria=Educa%C3%A7%C3%A3o">
                <div class="home-circulo">
                    <svg viewBox="0 0 24 24"><path d="M5 13.18v4L12 21l7-3.82v-4L12 17l-7-3.82zM12 3L1 9l11 6 9-4.91V17h2V9L12 3z"/></svg>
                </div>
                <strong>Educação</strong>
                <span>${n} ${n == 1 ? 'livro' : 'livros'}</span>
            </a>

            <c:set var="n" value="${empty contagem['Outros'] ? 0 : contagem['Outros']}"/>
            <a class="home-categoria" href="/catalogo?categoria=Outros">
                <div class="home-circulo">
                    <svg viewBox="0 0 24 24"><path d="M4 8h4V4H4v4zm6 12h4v-4h-4v4zm-6 0h4v-4H4v4zm0-6h4v-4H4v4zm6 0h4v-4h-4v4zm6-10v4h4V4h-4zm-6 4h4V4h-4v4zm6 6h4v-4h-4v4zm0 6h4v-4h-4v4z"/></svg>
                </div>
                <strong>Outros</strong>
                <span>${n} ${n == 1 ? 'livro' : 'livros'}</span>
            </a>

        </div>
    </section>

    <!-- ================= LIVROS EM DESTAQUE ================= -->
    <section class="home-secao">
        <div class="home-secao-topo">
            <h2>Livros em Destaque</h2>
            <a class="home-ver-todos" href="/catalogo">Ver todos &rarr;</a>
        </div>

        <c:choose>

            <c:when test="${empty destaques}">
                <p class="home-vazio">Em breve, novos livros por aqui.</p>
            </c:when>

            <c:otherwise>
                <div class="home-destaques">

                    <c:forEach var="livro" items="${destaques}">
                        <article class="home-livro">

                            <a class="home-livro-link" href="/catalogo" data-nome="<c:out value='${livro.nome}'/>">
                                <div class="home-capa">
                                    <div>
                                        <svg viewBox="0 0 24 24"><path d="M21 19V5c0-1.1-.9-2-2-2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2zM8.5 13.5l2.5 3.01L14.5 12l4.5 6H5l3.5-4.5z"/></svg>
                                    </div>
                                </div>
                                <h3><c:out value="${livro.nome}"/></h3>
                                <p class="home-autor"><c:out value="${livro.autor}"/></p>
                            </a>

                            <span class="home-preco"><fmt:formatNumber value="${livro.preco}" type="currency"/></span>

                            <form class="home-add" action="/carrinho" method="post">
                                <input type="hidden" name="acao" value="adicionar">
                                <input type="hidden" name="id" value="${livro.id}">
                                <input type="hidden" name="quantidade" value="1">
                                <button type="submit">Adicionar ao carrinho</button>
                            </form>

                        </article>
                    </c:forEach>

                </div>
            </c:otherwise>

        </c:choose>
    </section>

</main>

<%@ include file="/WEB-INF/rodape.jspf" %>

<script>
    // Clicar no livro em destaque abre o catalogo ja buscando por ele
    (function () {
        var links = document.querySelectorAll('.home-livro-link');

        Array.prototype.forEach.call(links, function (link) {
            link.href = '/catalogo?q=' + encodeURIComponent(link.getAttribute('data-nome') || '');
        });
    })();
</script>

</body>
</html>