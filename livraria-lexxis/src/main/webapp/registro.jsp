<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Criar conta - Lexxis Livraria</title>
    <link rel="stylesheet" href="/css/registro.css">
</head>
<body>

<main class="registro-card">

    <!-- ===== Lado esquerdo: marca ===== -->
    <section class="lado-marca">
        <img class="logo" src="/img/logo.png" alt="Lexxis Livraria" height="70">
        <img class="livros" src="/img/livros-login.png" alt="Pilha de livros Lexxis">
        <h2>Bem vindos à Lexxis</h2>
        <p>Descubra novos Mundos através da leitura</p>
    </section>

    <!-- ===== Lado direito: formulário ===== -->
    <section class="lado-form">

        <h1>Criar conta na Lexxis</h1>

        <c:if test="${not empty erro}">
            <div class="msg erro"><c:out value="${erro}"/></div>
        </c:if>

        <form action="/registro" method="post">

            <label class="campo">
                <svg viewBox="0 0 24 24" aria-hidden="true">
                    <circle cx="12" cy="7" r="4"/>
                    <path d="M4 21c0-4.5 3.5-7 8-7s8 2.5 8 7"/>
                </svg>
                <input type="text" name="nome" placeholder="Digite seu nome" required
                       autocomplete="name"
                       value="<c:out value="${param.nome}"/>">
            </label>

            <label class="campo">
                <svg viewBox="0 0 24 24" aria-hidden="true">
                    <rect x="3" y="5" width="18" height="14" rx="2"/>
                    <polyline points="3 7 12 13 21 7"/>
                </svg>
                <input type="email" name="email" placeholder="Digite seu e-mail" required
                       autocomplete="email"
                       value="<c:out value="${param.email}"/>">
            </label>

            <label class="campo">
                <svg viewBox="0 0 24 24" aria-hidden="true">
                    <rect x="4" y="11" width="16" height="10" rx="2" fill="currentColor"/>
                    <path d="M8 11V7a4 4 0 0 1 8 0v4"/>
                </svg>
                <input type="password" name="senha" placeholder="Senha (mínimo 6 caracteres)" required
                       minlength="6" autocomplete="new-password">
            </label>

            <label class="campo">
                <svg viewBox="0 0 24 24" aria-hidden="true">
                    <rect x="4" y="11" width="16" height="10" rx="2" fill="currentColor"/>
                    <path d="M8 11V7a4 4 0 0 1 8 0v4"/>
                </svg>
                <input type="password" name="confirmacao" placeholder="Confirmar senha" required
                       minlength="6" autocomplete="new-password">
            </label>

            <button type="submit" class="botao-criar">CRIAR CONTA</button>

        </form>

        <p class="ja-tem-conta">Já tem conta? <a href="/login">Entrar</a></p>

    </section>

</main>

</body>
</html>