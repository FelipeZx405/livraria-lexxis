<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="editando" value="${not empty livro}"/>
<c:set var="capaAtual" value="${editando and livro.temCapa}"/>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${editando ? 'Editar Livro' : 'Adicionar Livro'} - Livraria Lexxis</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/admin.css">

    <style>
        .campo-form select {
            width: 100%;
            padding: 12px 14px;
            background: #fff;
            border: 1px solid #bdbdbd;
            border-radius: 6px;
            font-family: inherit;
            font-size: 15px;
        }

        .campo-form select:focus {
            outline: 2px solid var(--marrom);
        }
    </style>
</head>
<body>

<%@ include file="/WEB-INF/menu.jspf" %>

<div class="admin-layout">

    <%@ include file="/WEB-INF/filtros.jspf" %>

    <main class="painel">

        <nav class="migalhas">
            <a href="/conta">Minha conta</a>
            <span>/</span>
            <span>${editando ? 'Editar Livro' : 'Adicionar Livro'}</span>
        </nav>

        <h1>${editando ? 'Editar Livro' : 'Adicionar Livro'}</h1>
        <p class="subtitulo">
            ${editando ? 'Altere as informações abaixo e salve o livro.' : 'Preencha as informações abaixo para adicionar um novo livro à loja.'}
        </p>

        <%-- enctype="multipart/form-data" é obrigatório para enviar arquivo --%>
        <form action="/create-livro" method="post" enctype="multipart/form-data">

            <%-- id vazio = livro novo; id preenchido = edição --%>
            <input type="hidden" name="id" value="<c:out value='${livro.id}'/>">

            <div class="form-grade">

                <div class="campo-form">
                    <label for="nome">Nome do Livro <span class="obrig">*</span></label>
                    <input type="text" id="nome" name="name" required maxlength="255"
                           placeholder="Digite o nome do livro..."
                           value="<c:out value='${livro.nome}'/>">
                </div>

                <div class="campo-form">
                    <label for="autor">Autor <span class="obrig">*</span></label>
                    <input type="text" id="autor" name="autor" required maxlength="255"
                           placeholder="Digite o nome do autor..."
                           value="<c:out value='${livro.autor}'/>">
                </div>

                <div class="campo-form larga">
                    <label for="descricao">Descrição <span class="obrig">*</span></label>
                    <textarea id="descricao" name="descricao" required maxlength="1000"
                              placeholder="Descreva o livro..."><c:out value='${livro.descricao}'/></textarea>
                </div>

                <div class="campo-form">
                    <label for="preco">Preço (R$) <span class="obrig">*</span></label>
                    <input type="number" id="preco" name="preco" required min="0" step="0.01"
                           placeholder="Ex: 49,90"
                           value="<c:out value='${livro.preco}'/>">
                </div>

                <div class="campo-form">
                    <label for="estoque">Quantidade em Estoque <span class="obrig">*</span></label>
                    <input type="number" id="estoque" name="estoque" required min="0" step="1"
                           placeholder="Ex: 10"
                           value="<c:out value='${livro.estoque}'/>">
                </div>

                <div class="campo-form">
                    <label for="categoria">Categoria <span class="obrig">*</span></label>
                    <select id="categoria" name="categoria" required>
                        <option value="" disabled ${empty livro.categoria ? 'selected' : ''}>Selecione a categoria...</option>
                        <c:forTokens items="Romance,Suspense,Ficção Científica,Comédia,Educação,Outros" delims="," var="cat">
                            <option value="${cat}" ${livro.categoria == cat ? 'selected' : ''}>${cat}</option>
                        </c:forTokens>
                    </select>
                </div>

                <div class="coluna-img">

                    <div class="campo-form">
                        <label for="capa">Imagem da Capa <span class="dica">(JPG, PNG, WEBP ou GIF, até 2 MB)</span></label>

                        <%-- clicar aqui abre o seletor de arquivo; também dá para arrastar a imagem --%>
                        <label class="dropzone" id="dropzone" for="capa">

                            <span class="dz-texto" id="dz-texto" ${capaAtual ? 'hidden' : ''}>
                                <svg viewBox="0 0 24 24"><path d="M9 16h6v-6h4l-7-7-7 7h4zm-4 2h14v2H5z"/></svg>
                                <span class="dz-titulo">Clique para adicionar uma imagem</span>
                                <span class="dz-sub">ou arraste e solte aqui</span>
                            </span>

                            <span class="dz-previa" id="dz-previa" ${capaAtual ? '' : 'hidden'}>
                                <span id="dz-img-box"><c:if test="${capaAtual}"><img src="/capa?id=${livro.id}&amp;v=${livro.capaVersao}" alt="Capa atual"></c:if></span>
                                <span class="dz-sub">Clique ou arraste outra imagem para trocar</span>
                            </span>

                        </label>

                        <input type="file" id="capa" name="capa" class="arquivo-oculto"
                               accept="image/jpeg,image/png,image/webp,image/gif">

                        <p class="aviso-capa" id="aviso-capa"></p>

                        <c:if test="${capaAtual}">
                            <label class="remover-capa">
                                <input type="checkbox" name="removerCapa" value="1"> Remover a capa atual
                            </label>
                        </c:if>
                    </div>

                    <div class="form-acoes">
                        <button type="submit" class="btn btn-marrom">Salvar Livro</button>
                        <a class="btn btn-contorno" href="/find-all-livros">Cancelar</a>
                    </div>

                </div>

            </div>

        </form>

    </main>
</div>

<%@ include file="/WEB-INF/rodape.jspf" %>

<script>
    (function () {

        var LIMITE = 2 * 1024 * 1024;
        var TIPOS = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'];

        var entrada = document.getElementById('capa');
        var zona = document.getElementById('dropzone');
        var texto = document.getElementById('dz-texto');
        var previa = document.getElementById('dz-previa');
        var caixa = document.getElementById('dz-img-box');
        var aviso = document.getElementById('aviso-capa');

        function limpar() {
            entrada.value = '';
            caixa.innerHTML = '';
            previa.hidden = true;
            texto.hidden = false;
        }

        function mostrar(arquivo) {

            aviso.textContent = '';

            if (!arquivo) { return; }

            if (TIPOS.indexOf(arquivo.type) === -1) {
                limpar();
                aviso.textContent = 'Use uma imagem JPG, PNG, WEBP ou GIF.';
                return;
            }

            if (arquivo.size > LIMITE) {
                limpar();
                aviso.textContent = 'A imagem tem mais de 2 MB. Escolha uma menor.';
                return;
            }

            var img = document.createElement('img');
            img.src = URL.createObjectURL(arquivo);
            img.alt = 'Prévia da capa';

            caixa.innerHTML = '';
            caixa.appendChild(img);

            previa.hidden = false;
            texto.hidden = true;
        }

        entrada.addEventListener('change', function () {
            mostrar(entrada.files[0]);
        });

        ['dragenter', 'dragover'].forEach(function (nome) {
            zona.addEventListener(nome, function (evento) {
                evento.preventDefault();
                zona.classList.add('arrastando');
            });
        });

        ['dragleave', 'drop'].forEach(function (nome) {
            zona.addEventListener(nome, function (evento) {
                evento.preventDefault();
                zona.classList.remove('arrastando');
            });
        });

        zona.addEventListener('drop', function (evento) {
            if (evento.dataTransfer && evento.dataTransfer.files.length > 0) {
                entrada.files = evento.dataTransfer.files;
                mostrar(entrada.files[0]);
            }
        });

    })();
</script>

</body>
</html>