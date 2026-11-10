package br.com.lexxis.model;

public class Usuario {

    private String id;
    private String nome;
    private String email;
    private String senha;
    private String perfil;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getSenha() {
        return senha;
    }

    public void setSenha(String senha) {
        this.senha = senha;
    }

    // "ADM" ou "CLIENTE"
    public String getPerfil() {
        return perfil;
    }

    public void setPerfil(String perfil) {
        this.perfil = perfil;
    }

    // o JSP usa como ${sessionScope.usuarioLogado.admin}
    public boolean isAdmin() {
        return "ADM".equals(perfil);
    }

}