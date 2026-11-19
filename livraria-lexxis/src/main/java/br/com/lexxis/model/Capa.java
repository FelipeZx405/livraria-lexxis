package br.com.lexxis.model;

// a imagem de capa de um livro: os bytes do arquivo e o tipo (image/jpeg, image/png...)
public class Capa {

    private byte[] dados;
    private String tipo;

    public Capa(byte[] dados, String tipo) {
        this.dados = dados;
        this.tipo = tipo;
    }

    public byte[] getDados() {
        return dados;
    }

    public String getTipo() {
        return tipo;
    }
}