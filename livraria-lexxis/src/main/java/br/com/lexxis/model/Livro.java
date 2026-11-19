package br.com.lexxis.model;

public class Livro {

    private String nome;
    private String id;
    private String autor;
    private String descricao;
    private double preco;
    private int estoque;
    private String categoria;
    private boolean temCapa;
    private long capaVersao;

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getAutor() {
        return autor;
    }

    public void setAutor(String autor) {
        this.autor = autor;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public double getPreco() {
        return preco;
    }

    public void setPreco(double preco) {
        this.preco = preco;
    }

    public int getEstoque() {
        return estoque;
    }

    public void setEstoque(int estoque) {
        this.estoque = estoque;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    // true se o livro tem imagem de capa (a imagem em si fica no banco e é entregue por /capa)
    public boolean isTemCapa() {
        return temCapa;
    }

    public void setTemCapa(boolean temCapa) {
        this.temCapa = temCapa;
    }

    // muda a cada nova capa; vai na URL da imagem para o navegador não mostrar uma versão antiga
    public long getCapaVersao() {
        return capaVersao;
    }

    public void setCapaVersao(long capaVersao) {
        this.capaVersao = capaVersao;
    }
}