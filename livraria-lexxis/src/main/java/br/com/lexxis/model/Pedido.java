package br.com.lexxis.model;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class Pedido {

    public static final String PIX = "PIX";
    public static final String CARTAO = "CARTAO";
    public static final String BOLETO = "BOLETO";

    public static final String AGUARDANDO = "AGUARDANDO_PAGAMENTO";
    public static final String PAGO = "PAGO";
    public static final String CANCELADO = "CANCELADO";

    private int id;
    private int usuarioId;
    private Date data;
    private double subtotal;
    private double frete;
    private double desconto;
    private double total;
    private String formaPagamento;
    private int parcelas = 1;
    private String cartaoFinal;
    private String situacao;
    private String destNome;
    private String cep;
    private String endereco;
    private String numero;
    private String complemento;
    private String bairro;
    private String cidade;
    private String uf;
    private List<ItemPedido> itens = new ArrayList<ItemPedido>();

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUsuarioId() { return usuarioId; }
    public void setUsuarioId(int usuarioId) { this.usuarioId = usuarioId; }

    public Date getData() { return data; }
    public void setData(Date data) { this.data = data; }

    public double getSubtotal() { return subtotal; }
    public void setSubtotal(double subtotal) { this.subtotal = subtotal; }

    public double getFrete() { return frete; }
    public void setFrete(double frete) { this.frete = frete; }

    public double getDesconto() { return desconto; }
    public void setDesconto(double desconto) { this.desconto = desconto; }

    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }

    public String getFormaPagamento() { return formaPagamento; }
    public void setFormaPagamento(String formaPagamento) { this.formaPagamento = formaPagamento; }

    public int getParcelas() { return parcelas; }
    public void setParcelas(int parcelas) { this.parcelas = parcelas; }

    public String getCartaoFinal() { return cartaoFinal; }
    public void setCartaoFinal(String cartaoFinal) { this.cartaoFinal = cartaoFinal; }

    public String getSituacao() { return situacao; }
    public void setSituacao(String situacao) { this.situacao = situacao; }

    public String getDestNome() { return destNome; }
    public void setDestNome(String destNome) { this.destNome = destNome; }

    public String getCep() { return cep; }
    public void setCep(String cep) { this.cep = cep; }

    public String getEndereco() { return endereco; }
    public void setEndereco(String endereco) { this.endereco = endereco; }

    public String getNumero() { return numero; }
    public void setNumero(String numero) { this.numero = numero; }

    public String getComplemento() { return complemento; }
    public void setComplemento(String complemento) { this.complemento = complemento; }

    public String getBairro() { return bairro; }
    public void setBairro(String bairro) { this.bairro = bairro; }

    public String getCidade() { return cidade; }
    public void setCidade(String cidade) { this.cidade = cidade; }

    public String getUf() { return uf; }
    public void setUf(String uf) { this.uf = uf; }

    public List<ItemPedido> getItens() { return itens; }
    public void setItens(List<ItemPedido> itens) { this.itens = itens; }

    // ---------- Auxiliares para o JSP ----------

    public boolean isPix() { return PIX.equals(formaPagamento); }
    public boolean isCartao() { return CARTAO.equals(formaPagamento); }
    public boolean isBoleto() { return BOLETO.equals(formaPagamento); }

    public boolean isAguardandoPagamento() { return AGUARDANDO.equals(situacao); }
    public boolean isPago() { return PAGO.equals(situacao); }
    public boolean isCancelado() { return CANCELADO.equals(situacao); }

    public String getFormaDescricao() {
        if (isPix()) return "Pix";
        if (isCartao()) return "Cartão de crédito";
        if (isBoleto()) return "Boleto bancário";
        return formaPagamento;
    }

    public String getSituacaoDescricao() {
        if (isAguardandoPagamento()) return "Aguardando pagamento";
        if (isPago()) return "Pago";
        if (isCancelado()) return "Cancelado";
        return situacao;
    }

    public int getQuantidadeTotal() {
        int soma = 0;
        for (ItemPedido item : itens) {
            soma += item.getQuantidade();
        }
        return soma;
    }

    public double getValorParcela() {
        if (parcelas <= 0) {
            return total;
        }
        return Math.round(total / parcelas * 100.0) / 100.0;
    }

    public String getCepFormatado() {
        if (cep != null && cep.length() == 8) {
            return cep.substring(0, 5) + "-" + cep.substring(5);
        }
        return cep;
    }

    // vencimento do boleto: 3 dias depois do pedido
    public Date getVencimentoBoleto() {
        Calendar c = Calendar.getInstance();
        if (data != null) {
            c.setTime(data);
        }
        c.add(Calendar.DAY_OF_MONTH, 3);
        return c.getTime();
    }

    // código SIMULADO (não é um Pix real)
    public String getCodigoPix() {
        return "PIX-DEMO-LEXXIS-" + String.format("%06d", id) + "-" + Math.round(total * 100);
    }

    // linha digitável SIMULADA (não é um boleto real)
    public String getLinhaDigitavel() {
        return String.format("23793.38128 60000.%06d 00000.%06d 1 %014d", id, id, Math.round(total * 100));
    }
}