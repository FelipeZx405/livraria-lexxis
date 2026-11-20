<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setLocale value="pt_BR"/>
<c:set var="formaSel" value="${empty param.forma ? 'PIX' : param.forma}"/>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Finalizar compra - Livraria Lexxis</title>
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/checkout.css">
</head>
<body>

<%@ include file="/WEB-INF/menu.jspf" %>

<div class="container">

    <div class="caminho">
        <a href="/home">Início</a>
        <span>/</span>
        <a href="/carrinho">Carrinho</a>
        <span>/</span>
        <span>Finalizar compra</span>
    </div>

    <h1>Finalizar compra</h1>
    <p class="subtitulo">Informe o endereço de entrega e escolha como pagar.</p>

    <p class="msg aviso">Ambiente de demonstração: nenhum pagamento real é processado. Não digite dados de cartões reais.</p>

    <c:if test="${not empty erro}">
        <p class="msg erro"><c:out value="${erro}"/></p>
    </c:if>

    <form action="/checkout" method="post" id="form-checkout" class="layout-checkout">

        <!-- ================= COLUNA ESQUERDA ================= -->
        <div>

            <!-- ---------- Endereço ---------- -->
            <section class="bloco">
                <h2>1. Endereço de entrega</h2>

                <div class="grade-campos">

                    <div class="campo larga">
                        <label for="nome">Nome de quem vai receber <span class="obrig">*</span></label>
                        <input type="text" id="nome" name="nome" required maxlength="255" autocomplete="name"
                               value="<c:out value='${not empty param.nome ? param.nome : sessionScope.usuarioLogado.nome}'/>">
                    </div>

                    <div class="campo c2">
                        <label for="cep">CEP <span class="obrig">*</span></label>
                        <input type="text" id="cep" name="cep" required maxlength="9" inputmode="numeric"
                               autocomplete="postal-code" placeholder="00000-000"
                               value="<c:out value='${param.cep}'/>">
                    </div>

                    <div class="campo c4">
                        <label for="endereco">Rua / Avenida <span class="obrig">*</span></label>
                        <input type="text" id="endereco" name="endereco" required maxlength="255"
                               autocomplete="address-line1" value="<c:out value='${param.endereco}'/>">
                    </div>

                    <div class="campo c2">
                        <label for="numero">Número <span class="obrig">*</span></label>
                        <input type="text" id="numero" name="numero" required maxlength="20"
                               value="<c:out value='${param.numero}'/>">
                    </div>

                    <div class="campo c4">
                        <label for="complemento">Complemento</label>
                        <input type="text" id="complemento" name="complemento" maxlength="100"
                               placeholder="Apto, bloco, referência..."
                               value="<c:out value='${param.complemento}'/>">
                    </div>

                    <div class="campo c2">
                        <label for="bairro">Bairro <span class="obrig">*</span></label>
                        <input type="text" id="bairro" name="bairro" required maxlength="100"
                               value="<c:out value='${param.bairro}'/>">
                    </div>

                    <div class="campo c2">
                        <label for="cidade">Cidade <span class="obrig">*</span></label>
                        <input type="text" id="cidade" name="cidade" required maxlength="100"
                               autocomplete="address-level2" value="<c:out value='${param.cidade}'/>">
                    </div>

                    <div class="campo c2">
                        <label for="uf">Estado <span class="obrig">*</span></label>
                        <select id="uf" name="uf" required>
                            <option value="">UF</option>
                            <c:forTokens items="AC,AL,AP,AM,BA,CE,DF,ES,GO,MA,MT,MS,MG,PA,PB,PR,PE,PI,RJ,RN,RS,RO,RR,SC,SP,SE,TO"
                                         delims="," var="sigla">
                                <option value="${sigla}" ${param.uf == sigla ? 'selected' : ''}>${sigla}</option>
                            </c:forTokens>
                        </select>
                    </div>

                </div>
            </section>

            <!-- ---------- Pagamento ---------- -->
            <section class="bloco">
                <h2>2. Forma de pagamento</h2>

                <!-- PIX -->
                <label class="forma">
                    <input type="radio" name="forma" value="PIX" ${formaSel == 'PIX' ? 'checked' : ''}>
                    <span class="forma-titulo">Pix <em class="selo-desc">5% de desconto</em></span>
                    <span class="forma-sub">Pague pelo app do seu banco com o código gerado.</span>
                </label>
                <div class="painel-forma" id="painel-PIX" ${formaSel == 'PIX' ? '' : 'hidden'}>
                    Ao confirmar o pedido, vamos gerar o código Pix para você copiar e colar no app do banco.
                </div>

                <!-- CARTÃO -->
                <label class="forma">
                    <input type="radio" name="forma" value="CARTAO" ${formaSel == 'CARTAO' ? 'checked' : ''}>
                    <span class="forma-titulo">Cartão de crédito</span>
                    <span class="forma-sub">Em até 6x sem juros (parcela mínima de R$ 20,00).</span>
                </label>
                <div class="painel-forma" id="painel-CARTAO" ${formaSel == 'CARTAO' ? '' : 'hidden'}>
                    <div class="grade-campos">

                        <div class="campo larga">
                            <label for="cartaoNumero">Número do cartão</label>
                            <input type="text" id="cartaoNumero" name="cartaoNumero" inputmode="numeric"
                                   autocomplete="off" maxlength="23" placeholder="0000 0000 0000 0000">
                        </div>

                        <div class="campo larga">
                            <label for="cartaoNome">Nome impresso no cartão</label>
                            <input type="text" id="cartaoNome" name="cartaoNome" maxlength="60" autocomplete="off">
                        </div>

                        <div class="campo">
                            <label for="cartaoValidade">Validade</label>
                            <input type="text" id="cartaoValidade" name="cartaoValidade" inputmode="numeric"
                                   autocomplete="off" maxlength="5" placeholder="MM/AA">
                        </div>

                        <div class="campo">
                            <label for="cartaoCvv">CVV</label>
                            <input type="text" id="cartaoCvv" name="cartaoCvv" inputmode="numeric"
                                   autocomplete="off" maxlength="4" placeholder="123">
                        </div>

                        <div class="campo larga">
                            <label for="parcelas">Parcelas</label>
                            <select id="parcelas" name="parcelas" data-sel="<c:out value='${param.parcelas}'/>"></select>
                        </div>

                    </div>
                </div>

                <!-- BOLETO -->
                <label class="forma">
                    <input type="radio" name="forma" value="BOLETO" ${formaSel == 'BOLETO' ? 'checked' : ''}>
                    <span class="forma-titulo">Boleto bancário</span>
                    <span class="forma-sub">Vencimento em 3 dias. O pedido é liberado após o pagamento.</span>
                </label>
                <div class="painel-forma" id="painel-BOLETO" ${formaSel == 'BOLETO' ? '' : 'hidden'}>
                    Ao confirmar o pedido, vamos gerar o boleto com a linha digitável para pagamento.
                </div>

            </section>

        </div>

        <!-- ================= RESUMO ================= -->
        <aside class="resumo" id="resumo"
               data-subtotal="${subtotal}"
               data-frete="${frete}"
               data-desconto-pix="${descontoPix}"
               data-max-parcelas="${maxParcelas}"
               data-parcela-min="${parcelaMinima}">

            <h2>Resumo do pedido</h2>

            <c:forEach var="item" items="${carrinho.itens}">
                <div class="resumo-item">
                    <div class="mini-foto">
                        <c:if test="${item.livro.temCapa}">
                            <img src="/capa?id=${item.livro.id}&amp;v=${item.livro.capaVersao}" alt="">
                        </c:if>
                    </div>
                    <span><c:out value="${item.livro.nome}"/><br><small>Qtd.: ${item.quantidade}</small></span>
                    <span><fmt:formatNumber value="${item.subtotal}" type="currency"/></span>
                </div>
            </c:forEach>

            <div class="linha topo">
                <span>Subtotal</span>
                <span><fmt:formatNumber value="${subtotal}" type="currency"/></span>
            </div>

            <div class="linha">
                <span>Frete</span>
                <span>
                    <c:choose>
                        <c:when test="${frete == 0}">Grátis</c:when>
                        <c:otherwise><fmt:formatNumber value="${frete}" type="currency"/></c:otherwise>
                    </c:choose>
                </span>
            </div>

            <div class="linha desconto" id="linha-desconto" hidden>
                <span>Desconto Pix (5%)</span>
                <span id="valor-desconto"></span>
            </div>

            <div class="linha total">
                <span>Total</span>
                <span id="valor-total"><fmt:formatNumber value="${totalBase}" type="currency"/></span>
            </div>

            <button type="submit" class="btn btn-marrom" id="btn-confirmar">Confirmar pedido</button>

            <c:if test="${frete > 0}">
                <p class="nota">Frete grátis em compras a partir de
                    <fmt:formatNumber value="${freteGratisAcima}" type="currency"/>.</p>
            </c:if>

            <a class="btn btn-contorno" href="/carrinho">Voltar ao carrinho</a>
        </aside>

    </form>

</div>

<%@ include file="/WEB-INF/rodape.jspf" %>

<script>
    (function () {

        var resumo = document.getElementById('resumo');
        var subtotal = parseFloat(resumo.getAttribute('data-subtotal')) || 0;
        var frete = parseFloat(resumo.getAttribute('data-frete')) || 0;
        var descontoPix = parseFloat(resumo.getAttribute('data-desconto-pix')) || 0;
        var maxParcelas = parseInt(resumo.getAttribute('data-max-parcelas'), 10) || 1;
        var parcelaMin = parseFloat(resumo.getAttribute('data-parcela-min')) || 20;

        var linhaDesconto = document.getElementById('linha-desconto');
        var valorDesconto = document.getElementById('valor-desconto');
        var valorTotal = document.getElementById('valor-total');
        var selectParcelas = document.getElementById('parcelas');
        var form = document.getElementById('form-checkout');
        var botao = document.getElementById('btn-confirmar');

        var camposCartao = ['cartaoNumero', 'cartaoNome', 'cartaoValidade', 'cartaoCvv'];
        var formas = ['PIX', 'CARTAO', 'BOLETO'];

        function moeda(valor) {
            return valor.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
        }

        function arredondar(valor) {
            return Math.round(valor * 100) / 100;
        }

        function formaAtual() {
            var marcada = document.querySelector('input[name="forma"]:checked');
            return marcada ? marcada.value : 'PIX';
        }

        function montarParcelas() {

            var totalCartao = arredondar(subtotal + frete);
            var n = Math.max(1, Math.min(maxParcelas, Math.floor(totalCartao / parcelaMin)));
            var anterior = selectParcelas.getAttribute('data-sel');

            selectParcelas.innerHTML = '';

            for (var i = 1; i <= n; i++) {
                var opcao = document.createElement('option');
                opcao.value = String(i);
                opcao.textContent = (i === 1)
                    ? 'À vista - ' + moeda(totalCartao)
                    : i + 'x de ' + moeda(arredondar(totalCartao / i)) + ' sem juros';
                if (String(i) === anterior) {
                    opcao.selected = true;
                }
                selectParcelas.appendChild(opcao);
            }
        }

        function atualizar() {

            var forma = formaAtual();
            var desconto = (forma === 'PIX') ? arredondar(subtotal * descontoPix) : 0;
            var total = arredondar(subtotal + frete - desconto);

            linhaDesconto.hidden = desconto === 0;
            valorDesconto.textContent = '- ' + moeda(desconto);
            valorTotal.textContent = moeda(total);

            formas.forEach(function (f) {
                document.getElementById('painel-' + f).hidden = (f !== forma);
            });

            camposCartao.forEach(function (id) {
                document.getElementById(id).required = (forma === 'CARTAO');
            });

            Array.prototype.forEach.call(document.querySelectorAll('label.forma'), function (rotulo) {
                var radio = rotulo.querySelector('input');
                if (radio.checked) {
                    rotulo.className = 'forma selecionada';
                } else {
                    rotulo.className = 'forma';
                }
            });
        }

        // ---------- máscaras ----------
        function digitos(texto) {
            return (texto || '').replace(/\D/g, '');
        }

        var cep = document.getElementById('cep');

        cep.addEventListener('input', function () {

            var d = digitos(cep.value).slice(0, 8);
            cep.value = d.length > 5 ? d.slice(0, 5) + '-' + d.slice(5) : d;

            if (d.length === 8) {
                buscarCep(d);
            }
        });

        document.getElementById('cartaoNumero').addEventListener('input', function (e) {
            var d = digitos(e.target.value).slice(0, 19);
            e.target.value = d.replace(/(.{4})/g, '$1 ').trim();
        });

        document.getElementById('cartaoValidade').addEventListener('input', function (e) {
            var d = digitos(e.target.value).slice(0, 4);
            e.target.value = d.length > 2 ? d.slice(0, 2) + '/' + d.slice(2) : d;
        });

        document.getElementById('cartaoCvv').addEventListener('input', function (e) {
            e.target.value = digitos(e.target.value).slice(0, 4);
        });

        // Preenche o endereço pelo CEP (ViaCEP). Se falhar, o cliente digita normalmente.
        function buscarCep(d) {

            if (!window.fetch) { return; }

            fetch('https://viacep.com.br/ws/' + d + '/json/')
                .then(function (resposta) { return resposta.json(); })
                .then(function (dados) {

                    if (!dados || dados.erro) { return; }

                    if (dados.logradouro) { document.getElementById('endereco').value = dados.logradouro; }
                    if (dados.bairro) { document.getElementById('bairro').value = dados.bairro; }
                    if (dados.localidade) { document.getElementById('cidade').value = dados.localidade; }
                    if (dados.uf) { document.getElementById('uf').value = dados.uf; }

                    document.getElementById('numero').focus();
                })
                .catch(function () { /* sem internet: segue normalmente */ });
        }

        Array.prototype.forEach.call(document.querySelectorAll('input[name="forma"]'), function (radio) {
            radio.addEventListener('change', atualizar);
        });

        // evita clicar duas vezes em "Confirmar pedido"
        form.addEventListener('submit', function () {
            botao.disabled = true;
            botao.textContent = 'Processando...';
        });

        // se o navegador restaurar a página pelo botão "voltar", libera o botão de novo
        window.addEventListener('pageshow', function () {
            botao.disabled = false;
            botao.textContent = 'Confirmar pedido';
        });

        montarParcelas();
        atualizar();

    })();
</script>

</body>
</html>