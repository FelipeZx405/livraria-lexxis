package br.com.lexxis.model;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class Carrinho {

    private final Map<String, ItemCarrinho> itens = new LinkedHashMap<String, ItemCarrinho>();

    public void adicionar(Livro livro, int quantidade) {

        ItemCarrinho item = itens.get(livro.getId());

        if (item == null) {
            itens.put(livro.getId(), new ItemCarrinho(livro, quantidade));
        } else {
            item.setQuantidade(item.getQuantidade() + quantidade);
        }
    }

    public void atualizar(String livroId, int quantidade) {

        ItemCarrinho item = itens.get(livroId);

        if (item == null) {
            return;
        }

        if (quantidade <= 0) {
            itens.remove(livroId);
        } else {
            item.setQuantidade(quantidade);
        }
    }

    public void remover(String livroId) {
        itens.remove(livroId);
    }

    public void limpar() {
        itens.clear();
    }

    public ItemCarrinho getItem(String livroId) {
        return itens.get(livroId);
    }

    public List<ItemCarrinho> getItens() {
        return new ArrayList<ItemCarrinho>(itens.values());
    }

    public double getTotal() {
        double total = 0;
        for (ItemCarrinho item : itens.values()) {
            total += item.getSubtotal();
        }
        return total;
    }

    public int getQuantidadeTotal() {
        int total = 0;
        for (ItemCarrinho item : itens.values()) {
            total += item.getQuantidade();
        }
        return total;
    }

    public boolean isVazio() {
        return itens.isEmpty();
    }


    public void sincronizar(List<Livro> livrosAtuais) {

        Iterator<Map.Entry<String, ItemCarrinho>> it = itens.entrySet().iterator();

        while (it.hasNext()) {

            ItemCarrinho item = it.next().getValue();
            Livro atual = null;

            for (Livro livro : livrosAtuais) {
                if (livro.getId() != null && livro.getId().equals(item.getLivro().getId())) {
                    atual = livro;
                    break;
                }
            }

            if (atual == null) {
                it.remove();
            } else {
                item.setLivro(atual);
            }
        }
    }
}
