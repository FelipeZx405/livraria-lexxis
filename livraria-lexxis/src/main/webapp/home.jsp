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
        /* ===== Cores e fontes: mude aqui e muda a Home inteira ===== */
        :root {
            --marrom: #5a2d0c;
            --marrom-escuro: #3f1e08;
            --marrom-claro: #8b4a1f;
            --creme: #faf6f1;
            --creme-2: #f0e4d8;
            --borda: #e6dccf;
            --texto: #1f1f1f;
            --texto-suave: #6b625a;
            --serif: Georgia, "Times New Roman", serif;
            --sombra: 0 10px 26px rgba(63, 30, 8, .14);
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background: var(--creme);
            color: var(--texto);
            font-size: 14px;
            line-height: 1.4;
        }

        a {
            color: inherit;
        }

        .home {
            max-width: 1100px;
            margin: 0 auto;
            padding: 0 20px 40px;
        }

        .home a:focus-visible,
        .home button:focus-visible {
            outline: 3px solid #d9a874;
            outline-offset: 2px;
        }

        /* ===== Animacoes ===== */
        @keyframes subir {
            from { opacity: 0; transform: translateY(22px); }
            to   { opacity: 1; transform: none; }
        }

        @keyframes entrar {
            from { opacity: 0; transform: translateY(20px) rotate(6deg); }
            to   { opacity: 1; transform: rotate(2deg); }
        }

        /* So esconde as secoes se o JavaScript estiver ativo (para aparecerem ao rolar) */
        .js .revelar {
            opacity: 0;
        }

        .js .revelar.visivel {
            animation: subir .7s ease forwards;
        }

        /* ===== Banner ===== */
        .home-hero {
            position: relative;
            display: grid;
            grid-template-columns: 1.3fr 1fr;
            gap: 40px;
            align-items: center;
            padding: 56px 48px;
            overflow: hidden;
            border-radius: 18px;
            color: #fff;
            background: linear-gradient(135deg, var(--marrom-escuro) 0%, #6b3510 60%, var(--marrom-claro) 100%);
        }

        .home-hero::before {
            content: "";
            position: absolute;
            top: -160px;
            right: -120px;
            width: 420px;
            height: 420px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(255, 255, 255, .15), transparent 70%);
        }

        .home-hero::after {
            content: "";
            position: absolute;
            bottom: -120px;
            left: -90px;
            width: 260px;
            height: 260px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(240, 180, 120, .25), transparent 70%);
        }

        .home-hero > * {
            position: relative;
            z-index: 1;
        }

        .home-hero-texto > * {
            animation: subir .7s ease both;
        }

        .home-hero-texto > :nth-child(2) { animation-delay: .08s; }
        .home-hero-texto > :nth-child(3) { animation-delay: .16s; }
        .home-hero-texto > :nth-child(4) { animation-delay: .24s; }
        .home-hero-texto > :nth-child(5) { animation-delay: .32s; }

        .home-etiqueta {
            display: inline-flex;
            align-items: center;
            padding: 5px 14px;
            border: 1px solid rgba(255, 255, 255, .28);
            border-radius: 999px;
            background: rgba(255, 255, 255, .14);
            font-size: 11px;
            font-weight: bold;
            letter-spacing: 1.5px;
            text-transform: uppercase;
        }

        .home-hero h1 {
            margin: 16px 0 14px;
            font-family: var(--serif);
            font-size: 46px;
            line-height: 1.08;
        }

        .home-hero h1 em {
            font-style: italic;
            color: #f3c89a;
        }

        .home-hero p {
            max-width: 480px;
            margin-bottom: 26px;
            font-size: 16px;
            color: rgba(255, 255, 255, .86);
        }

        .home-acoes {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
        }

        .home-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 13px 26px;
            border: 1px solid transparent;
            border-radius: 10px;
            background: #fff;
            color: var(--marrom-escuro);
            font-size: 14px;
            font-weight: bold;
            text-decoration: none;
            transition: transform .2s, box-shadow .2s, background .2s;
        }

        .home-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 18px rgba(0, 0, 0, .25);
        }

        .home-btn.secundario {
            background: transparent;
            border-color: rgba(255, 255, 255, .55);
            color: #fff;
        }

        .home-btn.secundario:hover {
            background: rgba(255, 255, 255, .14);
        }

        .home-stats {
            display: flex;
            gap: 32px;
            margin-top: 34px;
            list-style: none;
        }

        .home-stats strong {
            display: block;
            font-family: var(--serif);
            font-size: 28px;
        }

        .home-stats span {
            font-size: 11px;
            letter-spacing: 1px;
            text-transform: uppercase;
            color: rgba(255, 255, 255, .72);
        }

        .home-hero-img {
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            justify-self: center;
            width: 100%;
            max-width: 340px;
            aspect-ratio: 1 / 1;
            overflow: hidden;
            border-radius: 22px;
            background: var(--creme-2);
            box-shadow: 0 26px 50px rgba(0, 0, 0, .35);
            transform: rotate(2deg);
            animation: entrar .8s ease both;
            animation-delay: .15s;
        }

        .home-hero-img .fundo {
            position: absolute;
            width: 96px;
            height: 96px;
            fill: #d3bfa9;
        }

        .home-hero-img img {
            position: relative;
            width: 100%;
            height: 100%;
            padding: 14px;
            object-fit: contain;
        }

        /* ===== Secoes ===== */
        .home-secao {
            margin-top: 60px;
        }

        .home-secao-topo {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 22px;
        }

        .home-eyebrow {
            display: block;
            margin-bottom: 4px;
            font-size: 11px;
            font-weight: bold;
            letter-spacing: 2px;
            text-transform: uppercase;
            color: var(--marrom-claro);
        }

        .home-secao h2 {
            font-family: var(--serif);
            font-size: 28px;
        }

        .home-secao h2::after {
            content: "";
            display: block;
            width: 56px;
            height: 3px;
            margin-top: 8px;
            border-radius: 2px;
            background: linear-gradient(90deg, var(--marrom), #d9a874);
        }

        .home-ver-todos {
            display: inline-flex;
            align-items: center;
            padding: 8px 16px;
            border: 1px solid var(--borda);
            border-radius: 999px;
            background: #fff;
            font-size: 12px;
            font-weight: bold;
            text-decoration: none;
            transition: background .2s, color .2s, border-color .2s;
        }

        .home-ver-todos:hover {
            background: var(--marrom);
            border-color: var(--marrom);
            color: #fff;
        }

        .home-circulo {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 46px;
            height: 46px;
            margin-bottom: 8px;
            border-radius: 50%;
            background: var(--creme-2);
            transition: background .2s;
        }

        .home-circulo svg {
            width: 22px;
            height: 22px;
            fill: var(--marrom);
            transition: fill .2s;
        }

        /* ===== Proxima Sessao (atalhos) ===== */
        .home-atalhos {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
        }

        .home-atalho {
            position: relative;
            display: flex;
            flex-direction: column;
            gap: 4px;
            padding: 22px 20px 44px;
            border: 1px solid var(--borda);
            border-radius: 14px;
            background: #fff;
            text-decoration: none;
            transition: transform .2s, box-shadow .2s, border-color .2s;
        }

        .home-atalho:hover {
            transform: translateY(-4px);
            border-color: #d6c3ae;
            box-shadow: var(--sombra);
        }

        .home-atalho strong {
            font-size: 15px;
        }

        .home-atalho .sub {
            font-size: 12px;
            color: var(--texto-suave);
        }

        .home-atalho .seta {
            position: absolute;
            right: 18px;
            bottom: 14px;
            font-size: 18px;
            color: var(--marrom);
            transition: transform .2s;
        }

        .home-atalho:hover .seta {
            transform: translateX(5px);
        }

        .home-atalho.principal {
            border: 0;
            color: #fff;
            background: linear-gradient(135deg, var(--marrom), var(--marrom-claro));
        }

        .home-atalho.principal .sub {
            color: rgba(255, 255, 255, .82);
        }

        .home-atalho.principal .seta {
            color: #fff;
        }

        .home-atalho.principal .home-circulo {
            background: rgba(255, 255, 255, .18);
        }

        .home-atalho.principal .home-circulo svg {
            fill: #fff;
        }

        /* ===== Categorias ===== */
        .home-categorias {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 16px;
        }

        .home-categoria {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 6px;
            padding: 24px 12px;
            border: 1px solid var(--borda);
            border-radius: 14px;
            background: #fff;
            text-align: center;
            text-decoration: none;
            transition: transform .2s, box-shadow .2s, background .2s, border-color .2s, color .2s;
        }

        .home-categoria strong {
            font-size: 14px;
        }

        .home-categoria .contagem {
            padding: 2px 10px;
            border-radius: 999px;
            background: var(--creme-2);
            font-size: 11px;
            color: var(--texto-suave);
            transition: background .2s, color .2s;
        }

        .home-categoria:hover {
            transform: translateY(-4px);
            border-color: var(--marrom);
            background: var(--marrom);
            color: #fff;
            box-shadow: var(--sombra);
        }

        .home-categoria:hover .home-circulo {
            background: rgba(255, 255, 255, .16);
        }

        .home-categoria:hover svg {
            fill: #fff;
        }

        .home-categoria:hover .contagem {
            background: rgba(255, 255, 255, .18);
            color: #fff;
        }

        /* ===== Livros em destaque ===== */
        .home-destaques {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 28px;
        }

        .home-livro {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .home-livro-link {
            display: block;
            text-decoration: none;
            transition: transform .25s;
        }

        .home-livro-link:hover {
            transform: translateY(-6px) rotate(-1deg);
        }

        /* capa desenhada em CSS (cores trocam de livro para livro) */
        .home-capa-livro {
            --c1: #5a2d0c;
            --c2: #8b4a1f;
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            aspect-ratio: 3 / 4;
            padding: 20px 16px 16px 26px;
            overflow: hidden;
            border-radius: 4px 12px 12px 4px;
            background: linear-gradient(135deg, var(--c1), var(--c2));
            color: #fff;
            box-shadow: 0 14px 26px rgba(0, 0, 0, .28);
        }

        .home-capa-livro::before {
            content: "";
            position: absolute;
            top: 0;
            bottom: 0;
            left: 0;
            width: 12px;
            background: rgba(0, 0, 0, .28);
        }

        .home-capa-livro::after {
            content: "";
            position: absolute;
            right: -34px;
            bottom: -34px;
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: rgba(255, 255, 255, .13);
        }

        .home-livro:nth-child(4n+2) .home-capa-livro { --c1: #1f3a4d; --c2: #3d6f8e; }
        .home-livro:nth-child(4n+3) .home-capa-livro { --c1: #3b4a2a; --c2: #6b8a3f; }
        .home-livro:nth-child(4n+4) .home-capa-livro { --c1: #4a1f3b; --c2: #8a3d6f; }

        .home-capa-titulo {
            position: relative;
            z-index: 1;
            display: -webkit-box;
            overflow: hidden;
            font-family: var(--serif);
            font-size: 19px;
            font-weight: bold;
            line-height: 1.2;
            -webkit-line-clamp: 4;
            -webkit-box-orient: vertical;
        }

        .home-capa-autor {
            position: relative;
            z-index: 1;
            font-size: 11px;
            letter-spacing: .6px;
            text-transform: uppercase;
            opacity: .9;
        }

        .home-novo {
            position: absolute;
            top: 12px;
            right: 12px;
            z-index: 2;
            padding: 3px 10px;
            border-radius: 999px;
            background: #f3c89a;
            color: var(--marrom-escuro);
            font-size: 10px;
            font-weight: bold;
            letter-spacing: .5px;
            text-transform: uppercase;
        }

        .home-livro-info {
            display: flex;
            flex: 1;
            flex-direction: column;
            gap: 6px;
        }

        .home-livro-info h3 {
            font-size: 15px;
            line-height: 1.25;
        }

        .home-autor {
            font-size: 12px;
            color: var(--texto-suave);
        }

        .home-tag {
            align-self: flex-start;
            padding: 2px 10px;
            border-radius: 999px;
            background: var(--creme-2);
            color: var(--marrom);
            font-size: 10px;
            font-weight: bold;
            letter-spacing: .5px;
            text-transform: uppercase;
        }

        .home-aviso {
            font-size: 11px;
            font-weight: bold;
            color: #9a3412;
        }

        .home-livro-rodape {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
            margin-top: auto;
            padding-top: 4px;
        }

        .home-preco {
            font-family: var(--serif);
            font-size: 21px;
            font-weight: bold;
            color: var(--marrom);
        }

        .home-add button {
            padding: 9px 14px;
            border: 0;
            border-radius: 8px;
            background: var(--marrom);
            color: #fff;
            font-size: 12px;
            font-weight: bold;
            cursor: pointer;
            transition: background .2s, transform .2s;
        }

        .home-add button:hover {
            background: var(--marrom-escuro);
            transform: translateY(-1px);
        }

        .home-vazio {
            padding: 36px 16px;
            border: 1px dashed #c9b8a4;
            border-radius: 14px;
            background: #fff;
            color: var(--texto-suave);
            text-align: center;
        }

        /* ===== Faixa final ===== */
        .home-cta {
            position: relative;
            margin-top: 64px;
            padding: 48px 32px;
            overflow: hidden;
            border-radius: 18px;
            background: linear-gradient(135deg, var(--marrom-escuro), var(--marrom-claro));
            color: #fff;
            text-align: center;
        }

        .home-cta::before {
            content: "";
            position: absolute;
            top: -120px;
            left: -80px;
            width: 300px;
            height: 300px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(255, 255, 255, .14), transparent 70%);
        }

        .home-cta > * {
            position: relative;
        }

        .home-cta h2 {
            margin-bottom: 8px;
            font-family: var(--serif);
            font-size: 30px;
        }

        .home-cta p {
            margin-bottom: 24px;
            color: rgba(255, 255, 255, .86);
        }

        .home-cta .home-acoes {
            justify-content: center;
        }

        /* ===== Telas menores ===== */
        @media (max-width: 900px) {
            .home-hero {
                grid-template-columns: 1fr;
                padding: 38px 28px;
            }

            .home-hero-img {
                max-width: 240px;
            }

            .home-atalhos {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 520px) {
            .home-hero h1 {
                font-size: 32px;
            }

            .home-atalhos {
                grid-template-columns: 1fr;
            }

            .home-secao h2 {
                font-size: 24px;
            }

            .home-cta {
                padding: 36px 20px;
            }
        }

        /* Quem prefere menos movimento nao ve animacoes */
        @media (prefers-reduced-motion: reduce) {
            .js .revelar {
                opacity: 1;
            }

            .js .revelar.visivel,
            .home-hero-texto > *,
            .home-hero-img {
                animation: none;
            }

            * {
                transition: none !important;
            }
        }
    </style>
</head>
<body>

<script>document.documentElement.className += ' js';</script>

<%@ include file="/WEB-INF/menu.jspf" %>

<main class="home">

    <!-- ================= BANNER ================= -->
    <section class="home-hero">

        <div class="home-hero-texto">
            <span class="home-etiqueta">Livraria Lexxis</span>
            <h1>Descubra novos <em>mundos</em> através da leitura</h1>
            <p>Pesquise, escolha e compre livros de diferentes categorias e gêneros, em uma interface simples e intuitiva.</p>

            <div class="home-acoes">
                <a class="home-btn" href="/catalogo">Ver catálogo</a>
                <a class="home-btn secundario" href="#categorias">Explorar categorias</a>
            </div>

            <ul class="home-stats">
                <li><strong>${totalLivros}</strong><span>livros</span></li>
                <li><strong>6</strong><span>categorias</span></li>
            </ul>
        </div>

        <div class="home-hero-img">
            <svg class="fundo" viewBox="0 0 24 24" aria-hidden="true"><path d="M18 2H6c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zM6 4h5v8l-2.5-1.5L6 12V4z"/></svg>
            <img src="/img/livros-login.png" alt="Pilha de livros Lexxis" onerror="this.style.display='none'">
        </div>

    </section>

    <!-- ================= PROXIMA SESSAO (atalhos para o catalogo) ================= -->
    <section class="home-secao revelar">
        <div class="home-secao-topo">
            <div>
                <span class="home-eyebrow">Atalhos</span>
                <h2>Próxima Sessão</h2>
            </div>
        </div>

        <div class="home-atalhos">

            <a class="home-atalho principal" href="/catalogo">
                <div class="home-circulo">
                    <svg viewBox="0 0 24 24"><path d="M18 2H6c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zM6 4h5v8l-2.5-1.5L6 12V4z"/></svg>
                </div>
                <strong>Todos os livros</strong>
                <span class="sub">${totalLivros} no catálogo</span>
                <span class="seta">&rarr;</span>
            </a>

            <a class="home-atalho" href="/catalogo?ordem=menor">
                <div class="home-circulo">
                    <svg viewBox="0 0 24 24"><path d="M21.41 11.58l-9-9C12.05 2.22 11.55 2 11 2H4c-1.1 0-2 .9-2 2v7c0 .55.22 1.05.59 1.42l9 9c.36.36.86.58 1.41.58.55 0 1.05-.22 1.41-.59l7-7c.37-.36.59-.86.59-1.41 0-.55-.23-1.06-.59-1.42zM5.5 7C4.67 7 4 6.33 4 5.5S4.67 4 5.5 4 7 4.67 7 5.5 6.33 7 5.5 7z"/></svg>
                </div>
                <strong>Menor preço</strong>
                <span class="sub">Do mais barato ao mais caro</span>
                <span class="seta">&rarr;</span>
            </a>

            <a class="home-atalho" href="/catalogo?estoque=1">
                <div class="home-circulo">
                    <svg viewBox="0 0 24 24"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/></svg>
                </div>
                <strong>Disponíveis agora</strong>
                <span class="sub">Somente com estoque</span>
                <span class="seta">&rarr;</span>
            </a>

            <a class="home-atalho" href="/catalogo?ordem=nome">
                <div class="home-circulo">
                    <svg viewBox="0 0 24 24"><path d="M3 18h6v-2H3v2zM3 6v2h18V6H3zm0 7h12v-2H3v2z"/></svg>
                </div>
                <strong>Ordem alfabética</strong>
                <span class="sub">Do A ao Z</span>
                <span class="seta">&rarr;</span>
            </a>

        </div>
    </section>

    <!-- ================= CATEGORIAS ================= -->
    <section class="home-secao revelar" id="categorias">
        <div class="home-secao-topo">
            <div>
                <span class="home-eyebrow">Explore por gênero</span>
                <h2>Categorias</h2>
            </div>
        </div>

        <div class="home-categorias">

            <c:set var="n" value="${empty contagem['Romance'] ? 0 : contagem['Romance']}"/>
            <a class="home-categoria" href="/catalogo?categoria=Romance">
                <div class="home-circulo">
                    <svg viewBox="0 0 24 24"><path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/></svg>
                </div>
                <strong>Romance</strong>
                <span class="contagem">${n} ${n == 1 ? 'livro' : 'livros'}</span>
            </a>

            <c:set var="n" value="${empty contagem['Suspense'] ? 0 : contagem['Suspense']}"/>
            <a class="home-categoria" href="/catalogo?categoria=Suspense">
                <div class="home-circulo">
                    <svg viewBox="0 0 24 24"><path d="M15.5 14h-.79l-.28-.27A6.471 6.471 0 0 0 16 9.5 6.5 6.5 0 1 0 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/></svg>
                </div>
                <strong>Suspense</strong>
                <span class="contagem">${n} ${n == 1 ? 'livro' : 'livros'}</span>
            </a>

            <c:set var="n" value="${empty contagem['Ficção Científica'] ? 0 : contagem['Ficção Científica']}"/>
            <a class="home-categoria" href="/catalogo?categoria=Fic%C3%A7%C3%A3o%20Cient%C3%ADfica">
                <div class="home-circulo">
                    <svg viewBox="0 0 24 24"><path d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zm4.24 16L12 15.45 7.77 18l1.12-4.81-3.73-3.23 4.92-.42L12 5l1.92 4.53 4.92.42-3.73 3.23L16.23 18z"/></svg>
                </div>
                <strong>Ficção Científica</strong>
                <span class="contagem">${n} ${n == 1 ? 'livro' : 'livros'}</span>
            </a>

            <c:set var="n" value="${empty contagem['Comédia'] ? 0 : contagem['Comédia']}"/>
            <a class="home-categoria" href="/catalogo?categoria=Com%C3%A9dia">
                <div class="home-circulo">
                    <svg viewBox="0 0 24 24"><path d="M11.99 2C6.47 2 2 6.48 2 12s4.47 10 9.99 10C17.52 22 22 17.52 22 12S17.52 2 11.99 2zM12 20c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8zm3.5-9c.83 0 1.5-.67 1.5-1.5S16.33 8 15.5 8 14 8.67 14 9.5s.67 1.5 1.5 1.5zm-7 0c.83 0 1.5-.67 1.5-1.5S9.33 8 8.5 8 7 8.67 7 9.5 7.67 11 8.5 11zm3.5 6.5c2.33 0 4.31-1.46 5.11-3.5H6.89c.8 2.04 2.78 3.5 5.11 3.5z"/></svg>
                </div>
                <strong>Comédia</strong>
                <span class="contagem">${n} ${n == 1 ? 'livro' : 'livros'}</span>
            </a>

            <c:set var="n" value="${empty contagem['Educação'] ? 0 : contagem['Educação']}"/>
            <a class="home-categoria" href="/catalogo?categoria=Educa%C3%A7%C3%A3o">
                <div class="home-circulo">
                    <svg viewBox="0 0 24 24"><path d="M5 13.18v4L12 21l7-3.82v-4L12 17l-7-3.82zM12 3L1 9l11 6 9-4.91V17h2V9L12 3z"/></svg>
                </div>
                <strong>Educação</strong>
                <span class="contagem">${n} ${n == 1 ? 'livro' : 'livros'}</span>
            </a>

            <c:set var="n" value="${empty contagem['Outros'] ? 0 : contagem['Outros']}"/>
            <a class="home-categoria" href="/catalogo?categoria=Outros">
                <div class="home-circulo">
                    <svg viewBox="0 0 24 24"><path d="M4 8h4V4H4v4zm6 12h4v-4h-4v4zm-6 0h4v-4H4v4zm0-6h4v-4H4v4zm6 0h4v-4h-4v4zm6-10v4h4V4h-4zm-6 4h4V4h-4v4zm6 6h4v-4h-4v4zm0 6h4v-4h-4v4z"/></svg>
                </div>
                <strong>Outros</strong>
                <span class="contagem">${n} ${n == 1 ? 'livro' : 'livros'}</span>
            </a>

        </div>
    </section>

    <!-- ================= LIVROS EM DESTAQUE ================= -->
    <section class="home-secao revelar">
        <div class="home-secao-topo">
            <div>
                <span class="home-eyebrow">Novidades</span>
                <h2>Livros em Destaque</h2>
            </div>
            <a class="home-ver-todos" href="/catalogo">Ver todos &rarr;</a>
        </div>

        <c:choose>

            <c:when test="${empty destaques}">
                <p class="home-vazio">Em breve, novos livros por aqui.</p>
            </c:when>

            <c:otherwise>
                <div class="home-destaques">

                    <c:forEach var="livro" items="${destaques}" varStatus="st">
                        <article class="home-livro">

                            <a class="home-livro-link" href="/catalogo" data-nome="<c:out value='${livro.nome}'/>">
                                <div class="home-capa-livro">
                                    <c:if test="${st.first}">
                                        <span class="home-novo">Novo</span>
                                    </c:if>
                                    <span class="home-capa-titulo"><c:out value="${livro.nome}"/></span>
                                    <span class="home-capa-autor"><c:out value="${livro.autor}"/></span>
                                </div>
                            </a>

                            <div class="home-livro-info">
                                <h3><c:out value="${livro.nome}"/></h3>
                                <p class="home-autor"><c:out value="${livro.autor}"/></p>
                                <span class="home-tag"><c:out value="${empty livro.categoria ? 'Outros' : livro.categoria}"/></span>

                                <c:if test="${livro.estoque <= 3}">
                                    <span class="home-aviso">Últimas unidades</span>
                                </c:if>

                                <div class="home-livro-rodape">
                                    <span class="home-preco"><fmt:formatNumber value="${livro.preco}" type="currency"/></span>

                                    <form class="home-add" action="/carrinho" method="post">
                                        <input type="hidden" name="acao" value="adicionar">
                                        <input type="hidden" name="id" value="${livro.id}">
                                        <input type="hidden" name="quantidade" value="1">
                                        <button type="submit">Adicionar</button>
                                    </form>
                                </div>
                            </div>

                        </article>
                    </c:forEach>

                </div>
            </c:otherwise>

        </c:choose>
    </section>

    <!-- ================= FAIXA FINAL ================= -->
    <section class="home-cta revelar">
        <h2>Sua próxima leitura está a um clique</h2>

        <c:choose>

            <c:when test="${not empty sessionScope.usuarioLogado}">
                <p>Continue explorando o catálogo ou acompanhe os dados da sua conta.</p>
                <div class="home-acoes">
                    <a class="home-btn" href="/catalogo">Ver catálogo</a>
                    <a class="home-btn secundario" href="/conta">Minha conta</a>
                </div>
            </c:when>

            <c:otherwise>
                <p>Crie sua conta para usar o carrinho e comprar os seus livros favoritos.</p>
                <div class="home-acoes">
                    <a class="home-btn" href="/registro">Criar conta</a>
                    <a class="home-btn secundario" href="/catalogo">Ver catálogo</a>
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

    // As secoes aparecem suavemente conforme voce rola a pagina
    (function () {
        var secoes = document.querySelectorAll('.revelar');

        if (!('IntersectionObserver' in window)) {
            Array.prototype.forEach.call(secoes, function (secao) {
                secao.classList.add('visivel');
            });
            return;
        }

        var observador = new IntersectionObserver(function (entradas) {
            entradas.forEach(function (entrada) {
                if (entrada.isIntersecting) {
                    entrada.target.classList.add('visivel');
                    observador.unobserve(entrada.target);
                }
            });
        }, { threshold: 0.1 });

        Array.prototype.forEach.call(secoes, function (secao) {
            observador.observe(secao);
        });
    })();
</script>

</body>
</html>