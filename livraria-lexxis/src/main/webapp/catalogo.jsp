<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setLocale value="pt_BR"/>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Catálogo - Livraria Lexxis</title>

    <link rel="stylesheet" href="/css/style.css">

    <style>
        :root {
            --marrom: #5a2d0c;
            --marrom-escuro: #3f1e08;
            --cinza-fundo: #d9d9d9;
            --cinza-card: #e4e4e4;
            --texto: #1f1f1f;
            --texto-suave: #666;
            --mono: "Courier New", Courier, monospace;
        }

        [hidden] {
            display: none !important;
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

        /* ---------- Layout da pagina (filtros colados na esquerda) ---------- */
        .pagina {
            margin: 0;
            padding: 0 24px 24px 16px;
            display: grid;
            grid-template-columns: 250px 1fr;
            gap: 24px;
            align-items: start;
        }

        /* ---------- Filtros ---------- */
        .filtros {
            background: var(--cinza-fundo);
            border-radius: 6px;
            padding: 14px;
            position: sticky;
            top: 12px;
        }

        .filtros-topo {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-bottom: 8px;
            border-bottom: 1px solid #888;
        }

        .filtros h2 {
            font-family: var(--mono);
            font-size: 14px;
            letter-spacing: 1px;
        }

        .btn-limpar {
            background: none;
            border: 0;
            font-size: 11px;
            color: var(--texto-suave);
            text-decoration: underline;
            cursor: pointer;
        }

        .grupo {
            padding: 14px 0;
            border-bottom: 1px solid #888;
        }

        .grupo:last-child {
            border-bottom: 0;
            padding-bottom: 0;
        }

        .grupo h3 {
            font-family: var(--mono);
            font-size: 13px;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .em-breve {
            font-family: Arial, Helvetica, sans-serif;
            font-size: 10px;
            font-weight: normal;
            background: #bdbdbd;
            border-radius: 10px;
            padding: 1px 8px;
        }

        .opcao {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 12px;
            margin-bottom: 8px;
            cursor: pointer;
        }

        .opcao input {
            width: 14px;
            height: 14px;
        }

        .opcao.desativada {
            color: #777;
            cursor: default;
        }

        .qtd-cat {
            margin-left: auto;
            font-size: 11px;
            color: var(--texto-suave);
        }

        .campo {
            width: 100%;
            padding: 7px 8px;
            border: 1px solid #888;
            border-radius: 4px;
            background: #ececec;
            font-size: 12px;
        }

        .faixa {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            margin-bottom: 12px;
        }

        .btn-marrom {
            width: 100%;
            background: var(--marrom);
            color: #fff;
            border: 0;
            border-radius: 6px;
            padding: 10px;
            font-family: var(--mono);
            font-size: 13px;
            font-weight: bold;
            cursor: pointer;
        }

        .btn-marrom:hover {
            background: var(--marrom-escuro);
        }

        /* ---------- Lista de livros ---------- */
        .topo-lista {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px 16px;
            margin-bottom: 16px;
        }

        .titulo-lista {
            font-family: var(--mono);
            font-size: 14px;
            background: var(--cinza-fundo);
            padding: 6px 16px;
            border-radius: 6px;
        }

        .contador {
            font-size: 12px;
            color: var(--texto-suave);
        }

        .ordenar {
            margin-left: auto;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 12px;
        }

        .ordenar select {
            padding: 6px 8px;
            border: 1px solid #888;
            border-radius: 4px;
            background: #fff;
            font-size: 12px;
        }

        .grade {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(190px, 1fr));
            gap: 20px;
        }

        .card-livro {
            display: flex;
            flex-direction: column;
            background: var(--cinza-card);
            border: 1px solid #6b6b6b;
            border-radius: 4px;
            overflow: hidden;
            transition: box-shadow .15s, transform .15s;
        }

        .card-livro:hover {
            box-shadow: 0 6px 16px rgba(0, 0, 0, .15);
            transform: translateY(-2px);
        }

        .capa {
            position: relative;
            margin: 10px;
            background: #fff;
            border-radius: 6px;
            aspect-ratio: 3 / 4;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .capa svg {
            width: 48px;
            height: 48px;
            fill: #c4c4c4;
        }

        .selo {
            position: absolute;
            top: 8px;
            left: 8px;
            font-size: 10px;
            font-weight: bold;
            color: #fff;
            border-radius: 10px;
            padding: 2px 8px;
        }

        .selo.pouco {
            background: #9a3412;
        }

        .selo.esgotado {
            background: #6b6b6b;
        }

        .info {
            display: flex;
            flex-direction: column;
            gap: 3px;
            flex: 1;
            padding: 0 12px 12px;
        }

        .tag-cat {
            align-self: flex-start;
            margin-bottom: 4px;
            padding: 2px 8px;
            background: #cfcfcf;
            border-radius: 10px;
            color: #444;
            font-size: 10px;
            font-weight: bold;
            letter-spacing: .5px;
            text-transform: uppercase;
        }

        .nome {
            font-weight: bold;
            font-size: 14px;
        }

        .autor {
            font-size: 12px;
            color: var(--texto-suave);
        }

        .descricao {
            font-size: 12px;
            color: #555;
            margin-top: 4px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .preco {
            font-weight: bold;
            font-size: 16px;
            margin-top: 6px;
        }

        .comprar {
            display: flex;
            gap: 6px;
            margin-top: auto;
            padding-top: 10px;
        }

        .comprar input {
            width: 52px;
            padding: 6px;
            border: 1px solid #888;
            border-radius: 4px;
            font-size: 13px;
        }

        .btn-add {
            flex: 1;
            background: var(--marrom);
            color: #fff;
            border: 0;
            border-radius: 6px;
            font-size: 12px;
            font-weight: bold;
            cursor: pointer;
        }

        .btn-add:hover:not(:disabled) {
            background: var(--marrom-escuro);
        }

        .btn-add:disabled {
            background: #9a9a9a;
            cursor: not-allowed;
        }

        .sem-resultados {
            text-align: center;
            padding: 40px 16px;
            background: #f4f4f4;
            border: 1px dashed #bbb;
            border-radius: 8px;
            color: var(--texto-suave);
        }

        /* ---------- Celular ---------- */
        @media (max-width: 820px) {
            .pagina {
                grid-template-columns: 1fr;
            }

            .filtros {
                position: static;
            }
        }
    </style>
</head>
<body>

<%@ include file="/WEB-INF/menu.jspf" %>

<div class="pagina">

    <!-- ================= FILTROS ================= -->
    <aside class="filtros">

        <div class="filtros-topo">
            <h2>FILTROS</h2>
            <button type="button" class="btn-limpar" id="btn-limpar">Limpar filtros</button>
        </div>

        <div class="grupo">
            <h3>Categorias</h3>

            <c:forTokens items="Romance,Suspense,Ficção Científica,Comédia,Educação,Outros" delims="," var="cat">
                <label class="opcao">
                    <input type="checkbox" name="categoria" value="${cat}">
                    ${cat}
                    <span class="qtd-cat" data-cat="${cat}"></span>
                </label>
            </c:forTokens>
        </div>

        <div class="grupo">
            <h3>Autor</h3>
            <input type="text" class="campo" id="filtro-autor" placeholder="Pesquisar autor..." autocomplete="off">
        </div>

        <div class="grupo">
            <h3>Faixa de Preço</h3>
            <div class="faixa">
                <input type="number" class="campo" id="preco-min" min="0" step="0.01" placeholder="R$ 0">
                <span>até</span>
                <input type="number" class="campo" id="preco-max" min="0" step="0.01" placeholder="R$ 200">
            </div>
            <button type="button" class="btn-marrom" id="btn-aplicar">Aplicar Filtros</button>
        </div>

        <div class="grupo">
            <h3>Disponibilidade</h3>
            <label class="opcao"><input type="checkbox" id="so-estoque"> Somente com estoque</label>
        </div>

        <div class="grupo">
            <h3>Idioma <span class="em-breve">em breve</span></h3>
            <label class="opcao desativada"><input type="checkbox" disabled> Português</label>
            <label class="opcao desativada"><input type="checkbox" disabled> Inglês</label>
            <label class="opcao desativada"><input type="checkbox" disabled> Espanhol</label>
            <label class="opcao desativada"><input type="checkbox" disabled> Outros</label>
        </div>

    </aside>

    <!-- ================= LIVROS ================= -->
    <main>

        <div class="topo-lista">
            <h2 class="titulo-lista">LIVROS</h2>
            <span class="contador" id="contador"></span>

            <label class="ordenar">Ordenar por
                <select id="ordenar">
                    <option value="padrao">Padrão</option>
                    <option value="nome">Nome (A-Z)</option>
                    <option value="menor">Menor preço</option>
                    <option value="maior">Maior preço</option>
                </select>
            </label>
        </div>

        <div class="grade" id="grade">

            <c:forEach var="livro" items="${livros}">

                <c:set var="categoriaLivro" value="${empty livro.categoria ? 'Outros' : livro.categoria}"/>

                <article class="card-livro"
                         data-nome="<c:out value='${livro.nome}'/>"
                         data-autor="<c:out value='${livro.autor}'/>"
                         data-categoria="<c:out value='${categoriaLivro}'/>"
                         data-preco="${livro.preco}"
                         data-estoque="${livro.estoque}">

                    <div class="capa">
                        <svg viewBox="0 0 24 24"><path d="M21 19V5c0-1.1-.9-2-2-2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2zM8.5 13.5l2.5 3.01L14.5 12l4.5 6H5l3.5-4.5z"/></svg>

                        <c:choose>
                            <c:when test="${livro.estoque <= 0}">
                                <span class="selo esgotado">Esgotado</span>
                            </c:when>
                            <c:when test="${livro.estoque <= 3}">
                                <span class="selo pouco">Últimas unidades</span>
                            </c:when>
                        </c:choose>
                    </div>

                    <div class="info">
                        <span class="tag-cat"><c:out value="${categoriaLivro}"/></span>

                        <p class="nome"><c:out value="${livro.nome}"/></p>
                        <p class="autor"><c:out value="${livro.autor}"/></p>

                        <c:if test="${not empty livro.descricao}">
                            <p class="descricao"><c:out value="${livro.descricao}"/></p>
                        </c:if>

                        <p class="preco"><fmt:formatNumber value="${livro.preco}" type="currency"/></p>

                        <form class="comprar" action="/carrinho" method="post">
                            <input type="hidden" name="acao" value="adicionar">
                            <input type="hidden" name="id" value="${livro.id}">
                            <input type="number" name="quantidade" value="1" min="1" max="${livro.estoque}"
                                   aria-label="Quantidade" ${livro.estoque <= 0 ? 'disabled' : ''}>
                            <button type="submit" class="btn-add" ${livro.estoque <= 0 ? 'disabled' : ''}>
                                Adicionar
                            </button>
                        </form>
                    </div>
                </article>
            </c:forEach>

        </div>

        <div class="sem-resultados" id="sem-resultados" hidden>
            <c:choose>
                <c:when test="${empty livros}">Nenhum livro cadastrado ainda.</c:when>
                <c:otherwise>Nenhum livro encontrado com esses filtros.</c:otherwise>
            </c:choose>
        </div>

    </main>
</div>

<%@ include file="/WEB-INF/rodape.jspf" %>

<script>
    (function () {

        // Remove acentos para a busca ("principe" encontra "Príncipe")
        var DIACRITICOS = new RegExp('[' + String.fromCharCode(768) + '-' + String.fromCharCode(879) + ']', 'g');

        function normalizar(texto) {
            var t = (texto || '').toLowerCase();
            if (t.normalize) {
                t = t.normalize('NFD').replace(DIACRITICOS, '');
            }
            return t;
        }

        var grade = document.getElementById('grade');
        var cards = Array.prototype.slice.call(grade.querySelectorAll('.card-livro'));

        var campoBusca = document.getElementById('busca');
        var campoAutor = document.getElementById('filtro-autor');
        var campoMin = document.getElementById('preco-min');
        var campoMax = document.getElementById('preco-max');
        var campoEstoque = document.getElementById('so-estoque');
        var campoOrdem = document.getElementById('ordenar');
        var contador = document.getElementById('contador');
        var semResultados = document.getElementById('sem-resultados');
        var checksCategoria = Array.prototype.slice.call(document.querySelectorAll('input[name="categoria"]'));

        // Prepara os dados de cada card uma unica vez
        cards.forEach(function (card, indice) {
            card._ordem = indice;
            card._nome = normalizar(card.getAttribute('data-nome'));
            card._autor = normalizar(card.getAttribute('data-autor'));
            card._categoria = normalizar(card.getAttribute('data-categoria'));
            card._preco = parseFloat(card.getAttribute('data-preco')) || 0;
            card._estoque = parseInt(card.getAttribute('data-estoque'), 10) || 0;
        });

        // Mostra ao lado de cada categoria quantos livros existem nela
        Array.prototype.slice.call(document.querySelectorAll('.qtd-cat')).forEach(function (span) {
            var alvo = normalizar(span.getAttribute('data-cat'));
            var total = cards.filter(function (card) {
                return card._categoria === alvo;
            }).length;
            span.textContent = '(' + total + ')';
        });

        function ordenar() {

            var ordem = campoOrdem.value;
            var lista = cards.slice();

            lista.sort(function (a, b) {
                if (ordem === 'menor') { return a._preco - b._preco; }
                if (ordem === 'maior') { return b._preco - a._preco; }
                if (ordem === 'nome') { return a._nome.localeCompare(b._nome); }
                return a._ordem - b._ordem;
            });

            lista.forEach(function (card) {
                grade.appendChild(card);
            });
        }

        function aplicar() {

            var busca = normalizar(campoBusca.value.trim());
            var autor = normalizar(campoAutor.value.trim());
            var min = parseFloat(campoMin.value);
            var max = parseFloat(campoMax.value);
            var apenasEstoque = campoEstoque.checked;
            var visiveis = 0;

            // categorias marcadas (se nenhuma estiver marcada, mostra todas)
            var categoriasMarcadas = checksCategoria
                .filter(function (check) { return check.checked; })
                .map(function (check) { return normalizar(check.value); });

            cards.forEach(function (card) {

                var ok = true;

                if (busca && card._nome.indexOf(busca) === -1 && card._autor.indexOf(busca) === -1) { ok = false; }
                if (autor && card._autor.indexOf(autor) === -1) { ok = false; }
                if (categoriasMarcadas.length > 0 && categoriasMarcadas.indexOf(card._categoria) === -1) { ok = false; }
                if (!isNaN(min) && card._preco < min) { ok = false; }
                if (!isNaN(max) && card._preco > max) { ok = false; }
                if (apenasEstoque && card._estoque <= 0) { ok = false; }

                card.hidden = !ok;

                if (ok) { visiveis++; }
            });

            ordenar();

            contador.textContent = visiveis + (visiveis === 1 ? ' livro encontrado' : ' livros encontrados');
            semResultados.hidden = visiveis > 0;
        }

        function limpar() {
            campoBusca.value = '';
            campoAutor.value = '';
            campoMin.value = '';
            campoMax.value = '';
            campoEstoque.checked = false;
            campoOrdem.value = 'padrao';
            checksCategoria.forEach(function (check) { check.checked = false; });
            aplicar();
        }

        campoBusca.addEventListener('input', aplicar);
        campoAutor.addEventListener('input', aplicar);
        campoMin.addEventListener('input', aplicar);
        campoMax.addEventListener('input', aplicar);
        campoEstoque.addEventListener('change', aplicar);
        campoOrdem.addEventListener('change', aplicar);
        checksCategoria.forEach(function (check) {
            check.addEventListener('change', aplicar);
        });

        document.getElementById('btn-aplicar').addEventListener('click', aplicar);
        document.getElementById('btn-limpar').addEventListener('click', limpar);

        aplicar();

    })();
</script>

</body>
</html>