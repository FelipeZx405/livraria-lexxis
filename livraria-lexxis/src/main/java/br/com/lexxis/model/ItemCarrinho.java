package br.com.lexxis.model;

public class ItemCarrinho {

    private Livro livro;
    private int quantidade;

    public ItemCarrinho(Livro livro, int quantidade) {
        this.livro = livro;
        this.quantidade = quantidade;
    }

    public Livro getLivro() {
        return livro;
    }

    public void setLivro(Livro livro) {
        this.livro = livro;
    }

    public int getQuantidade() {
        return quantidade;
    }

    public void setQuantidade(int quantidade) {
        this.quantidade = quantidade;
    }

    public double getSubtotal() {
        return livro.getPreco() * quantidade;
    }
}
