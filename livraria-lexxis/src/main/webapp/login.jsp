<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Entrar - Lexxis Livraria</title>
    <link rel="stylesheet" href="/css/login.css">
</head>
<body>

<main class="login-card">

    <!-- ===== Lado esquerdo: marca ===== -->
    <section class="lado-marca">
        <img class="logo" src="/img/logo.png" alt="Lexxis Livraria" height="70">
        <img class="livros" src="/img/livros-login.png" alt="Pilha de livros Lexxis">
        <h2>Bem vindos à Lexxis</h2>
        <p>Descubra novos Mundos através da leitura</p>
    </section>

    <!-- ===== Lado direito: formulário ===== -->
    <section class="lado-form">

        <h1>Entrar na Lexxis</h1>

        <c:if test="${param.registrado == '1'}">
            <div class="msg ok">Conta criada com sucesso! Faça login.</div>
        </c:if>

        <c:if test="${not empty erro}">
            <div class="msg erro"><c:out value="${erro}"/></div>
        </c:if>

        <form action="/login" method="post">

            <label class="campo">
                <svg viewBox="0 0 24 24" aria-hidden="true">
                    <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/>
                    <polyline points="10 17 15 12 10 7"/>
                    <line x1="15" y1="12" x2="3" y2="12"/>
                </svg>
                <input type="email" name="email" placeholder="Digite seu e-mail" required
                       value="<c:out value="${param.email}"/>">
            </label>

            <label class="campo">
                <svg viewBox="0 0 24 24" aria-hidden="true">
                    <rect x="4" y="11" width="16" height="10" rx="2" fill="currentColor"/>
                    <path d="M8 11V7a4 4 0 0 1 8 0v4"/>
                </svg>
                <input type="password" name="senha" placeholder="Senha" required>
            </label>

            <a href="#" class="esqueceu">Esqueceu a senha?</a>

            <button type="submit" class="botao-entrar">ENTRAR</button>

        </form>

        <a href="/registro" class="criar-conta">Criar conta</a>

    </section>

</main>

</body>
</html>