package br.com.lexxis.model;

public class ItemPedido {

    private String livroId;
    private String nome;
    private String autor;
    private double preco;
    private int quantidade;

    public ItemPedido() {
    }

    public ItemPedido(String livroId, String nome, String autor, double preco, int quantidade) {
        this.livroId = livroId;
        this.nome = nome;
        this.autor = autor;
        this.preco = preco;
        this.quantidade = quantidade;
    }

    public String getLivroId() { return livroId; }
    public void setLivroId(String livroId) { this.livroId = livroId; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getAutor() { return autor; }
    public void setAutor(String autor) { this.autor = autor; }

    public double getPreco() { return preco; }
    public void setPreco(double preco) { this.preco = preco; }

    public int getQuantidade() { return quantidade; }
    public void setQuantidade(int quantidade) { this.quantidade = quantidade; }

    public double getSubtotal() {
        return Math.round(preco * quantidade * 100.0) / 100.0;
    }
}