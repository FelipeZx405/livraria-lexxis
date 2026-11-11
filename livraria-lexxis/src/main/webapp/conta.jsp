<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Minha conta - Livraria Lexxis</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/conta.css">
</head>
<body>

<%@ include file="/WEB-INF/menu.jspf" %>

<div class="container">

    <h1>Minha conta</h1>
    <p class="subtitulo">Veja e atualize os seus dados de acesso.</p>

    <!-- Resumo da conta -->
    <div class="perfil">
        <div class="avatar">${fn:toUpperCase(fn:substring(sessionScope.usuarioLogado.nome, 0, 1))}</div>
        <div>
            <p class="nome"><c:out value="${sessionScope.usuarioLogado.nome}"/></p>
            <p class="email"><c:out value="${sessionScope.usuarioLogado.email}"/></p>
        </div>
    </div>

    <c:if test="${param.ok == 'dados'}">
        <div class="msg ok">Dados atualizados com sucesso.</div>
    </c:if>
    <c:if test="${param.ok == 'senha'}">
        <div class="msg ok">Senha alterada com sucesso.</div>
    </c:if>

    <div class="grade">

        <!-- ========== Meus dados ========== -->
        <section class="card">
            <h2>Meus dados</h2>

            <c:if test="${secaoErro == 'dados'}">
                <div class="msg erro"><c:out value="${erro}"/></div>
            </c:if>

            <form action="/conta" method="post">
                <input type="hidden" name="acao" value="dados">

                <label for="nome">Nome</label>
                <input type="text" id="nome" name="nome" required
                       value="<c:out value="${not empty param.nome ? param.nome : sessionScope.usuarioLogado.nome}"/>">

                <label for="email">E-mail</label>
                <input type="email" id="email" name="email" required
                       value="<c:out value="${not empty param.email ? param.email : sessionScope.usuarioLogado.email}"/>">

                <button type="submit" class="btn btn-marrom">Salvar dados</button>
            </form>
        </section>

        <!-- ========== Alterar senha ========== -->
        <section class="card">
            <h2>Alterar senha</h2>

            <c:if test="${secaoErro == 'senha'}">
                <div class="msg erro"><c:out value="${erro}"/></div>
            </c:if>

            <form action="/conta" method="post">
                <input type="hidden" name="acao" value="senha">

                <label for="senhaAtual">Senha atual</label>
                <input type="password" id="senhaAtual" name="senhaAtual" required autocomplete="current-password">

                <label for="novaSenha">Nova senha (mínimo 6 caracteres)</label>
                <input type="password" id="novaSenha" name="novaSenha" required minlength="6" autocomplete="new-password">

                <label for="confirmacao">Confirmar nova senha</label>
                <input type="password" id="confirmacao" name="confirmacao" required minlength="6" autocomplete="new-password">

                <button type="submit" class="btn btn-marrom">Alterar senha</button>
            </form>
        </section>

    </div>

        <!-- ========== Ações ========== -->
        <div class="acoes-conta">
            <a class="btn btn-contorno" href="/catalogo">Voltar ao catálogo</a>
        <c:if test="${sessionScope.usuarioLogado.admin}">
            <a class="btn btn-contorno" href="/form-livro">Adicionar livro</a>
            <a class="btn btn-contorno" href="/find-all-livros">Editar e excluir livros</a>
        </c:if>

            <a class="btn btn-sair" href="/logout">Sair da conta</a>
        </div>

</div>

<%@ include file="/WEB-INF/rodape.jspf" %>

</body>
</html>