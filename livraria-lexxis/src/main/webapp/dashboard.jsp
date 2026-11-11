<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setLocale value="pt_BR"/>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Editar e Excluir Livro - Livraria Lexxis</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/admin.css">
</head>
<body>

<%@ include file="/WEB-INF/menu.jspf" %>

<div class="admin-layout">

    <%@ include file="/WEB-INF/filtros.jspf" %>

    <main class="painel">

        <nav class="migalhas">
            <a href="/conta">Minha conta</a>
            <span>/</span>
            <span>Editar e Excluir Livro</span>
        </nav>

        <div class="painel-topo">
            <div>
                <h1>Editar e Excluir Livro</h1>
                <p class="subtitulo">Gerencie os livros cadastrados na sua loja.</p>
            </div>

            <div class="topo-acoes">
                <label class="busca-livro">
                    <svg viewBox="0 0 24 24">
                        <circle cx="10.5" cy="10.5" r="6.5"/>
                        <path d="m16 16 5 5"/>
                    </svg>
                    <input type="text" id="busca-livro" placeholder="Buscar por nome do livro..." autocomplete="off">
                </label>
                <a class="btn btn-marrom" href="/form-livro">+ Adicionar livro</a>
            </div>
        </div>

        <div class="tabela-wrap">
            <table class="tabela" id="tabela-livros">
                <thead>
                <tr>
                    <th class="col-capa">Capa</th>
                    <th>Nome do Livro</th>
                    <th>Autor</th>
                    <th>Preço</th>
                    <th>Estoque</th>
                    <th class="col-acoes">Ações</th>
                </tr>
                </thead>
                <tbody>

                <c:forEach var="livro" items="${livros}">
                    <tr class="linha-livro"
                        data-nome="<c:out value='${livro.nome}'/>"
                        data-autor="<c:out value='${livro.autor}'/>"
                        data-preco="${livro.preco}">

                        <td class="col-capa">
                            <div class="capa-mini">
                                <svg viewBox="0 0 24 24"><path d="M21 19V5c0-1.1-.9-2-2-2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2zM8.5 13.5l2.5 3.01L14.5 12l4.5 6H5l3.5-4.5z"/></svg>
                            </div>
                        </td>

                        <td><c:out value="${livro.nome}"/></td>
                        <td><c:out value="${livro.autor}"/></td>
                        <td><fmt:formatNumber value="${livro.preco}" type="currency"/></td>
                        <td>${livro.estoque}</td>

                        <td class="col-acoes">
                            <div class="acoes">

                                <a class="btn btn-contorno" href="/form-livro?id=${livro.id}">
                                    <svg viewBox="0 0 24 24"><path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04a1.003 1.003 0 0 0 0-1.42l-2.34-2.34a1.003 1.003 0 0 0-1.42 0l-1.83 1.83 3.75 3.75 1.83-1.82z"/></svg>
                                    Editar
                                </a>

                                <form action="/delete-livro" method="post"
                                      onsubmit="return confirm('Excluir este livro?');">
                                    <input type="hidden" name="id" value="${livro.id}">
                                    <button type="submit" class="btn btn-marrom">
                                        <svg viewBox="0 0 24 24"><path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/></svg>
                                        Excluir
                                    </button>
                                </form>

                            </div>
                        </td>
                    </tr>
                </c:forEach>

                </tbody>
            </table>
        </div>

        <c:if test="${empty livros}">
            <p class="sem-resultados">Nenhum livro cadastrado ainda.</p>
        </c:if>
        <p class="sem-resultados" id="sem-resultados" hidden>Nenhum livro encontrado com esses filtros.</p>

        <div class="rodape-tabela">
            <span id="info-pagina"></span>
            <div class="paginacao" id="paginacao"></div>
        </div>

    </main>
</div>

<%@ include file="/WEB-INF/rodape.jspf" %>

<script>
    (function () {

        var POR_PAGINA = 5;

        // Remove acentos para a busca ("principe" encontra "Príncipe")
        var DIACRITICOS = new RegExp('[' + String.fromCharCode(768) + '-' + String.fromCharCode(879) + ']', 'g');

        function normalizar(texto) {
            var t = (texto || '').toLowerCase();
            if (t.normalize) {
                t = t.normalize('NFD').replace(DIACRITICOS, '');
            }
            return t;
        }

        var linhas = Array.prototype.slice.call(document.querySelectorAll('#tabela-livros tbody tr.linha-livro'));

        var campoNome = document.getElementById('busca-livro');
        var campoAutor = document.getElementById('f-autor');
        var campoMin = document.getElementById('f-min');
        var campoMax = document.getElementById('f-max');
        var info = document.getElementById('info-pagina');
        var paginacao = document.getElementById('paginacao');
        var semResultados = document.getElementById('sem-resultados');
        var formFiltros = document.getElementById('form-filtros');

        var pagina = 1;

        // Prepara os dados de cada linha uma única vez
        linhas.forEach(function (linha) {
            linha._nome = normalizar(linha.getAttribute('data-nome'));
            linha._autor = normalizar(linha.getAttribute('data-autor'));
            linha._preco = parseFloat(linha.getAttribute('data-preco')) || 0;
        });

        function filtradas() {

            var nome = normalizar(campoNome.value.trim());
            var autor = normalizar(campoAutor.value.trim());
            var min = parseFloat(campoMin.value);
            var max = parseFloat(campoMax.value);

            return linhas.filter(function (linha) {
                if (nome && linha._nome.indexOf(nome) === -1) { return false; }
                if (autor && linha._autor.indexOf(autor) === -1) { return false; }
                if (!isNaN(min) && linha._preco < min) { return false; }
                if (!isNaN(max) && linha._preco > max) { return false; }
                return true;
            });
        }

        function botao(texto, desativado, ativo, aoClicar) {
            var b = document.createElement('button');
            b.type = 'button';
            b.className = 'pag-btn' + (ativo ? ' ativo' : '');
            b.textContent = texto;
            b.disabled = desativado;
            b.addEventListener('click', aoClicar);
            return b;
        }

        function desenhar() {

            var lista = filtradas();
            var total = lista.length;
            var paginas = Math.max(1, Math.ceil(total / POR_PAGINA));

            if (pagina > paginas) { pagina = paginas; }

            var inicio = (pagina - 1) * POR_PAGINA;
            var fim = Math.min(inicio + POR_PAGINA, total);

            linhas.forEach(function (linha) { linha.hidden = true; });
            lista.slice(inicio, fim).forEach(function (linha) { linha.hidden = false; });

            if (total === 0) {
                info.textContent = 'Nenhum livro para mostrar';
            } else {
                info.textContent = 'Mostrando ' + (inicio + 1) + ' a ' + fim + ' de ' + total + (total === 1 ? ' livro' : ' livros');
            }

            semResultados.hidden = total > 0 || linhas.length === 0;

            paginacao.innerHTML = '';

            paginacao.appendChild(botao('‹', pagina === 1, false, function () {
                pagina--;
                desenhar();
            }));

            for (var i = 1; i <= paginas; i++) {
                (function (n) {
                    paginacao.appendChild(botao(String(n), false, n === pagina, function () {
                        pagina = n;
                        desenhar();
                    }));
                })(i);
            }

            paginacao.appendChild(botao('›', pagina === paginas, false, function () {
                pagina++;
                desenhar();
            }));
        }

        [campoNome, campoAutor, campoMin, campoMax].forEach(function (campo) {
            campo.addEventListener('input', function () {
                pagina = 1;
                desenhar();
            });
        });

        // "Aplicar Filtros" filtra na própria página, sem recarregar
        formFiltros.addEventListener('submit', function (evento) {
            evento.preventDefault();
            pagina = 1;
            desenhar();
        });

        desenhar();

    })();
</script>

</body>
</html>