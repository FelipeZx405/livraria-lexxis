<html>
<body>
<h2>Livraria Lexxis</h2>

<form action="/create-livro" method="post">

    <label>Nome do Livro:</label>
    <input type="text" name="name" id="name"  value="${param.name}">
    <input type="hidden" id="name" name="id" value="${param.id}">

    <br><label>Autor:</label>
    <input type="text" name="autor" value="${param.autor}">

    <br><label>Descricao:</label>
    <input type="text" name="descricao" value="${param.descricao}">

    <br><label>Preco:</label>
    <input type="number" step="0.01" min="0" name="preco" value="${param.preco}">
    <br>

    <br><label>Estoque:</label>
    <input type="number" min="0" step="1" name="estoque" value="${param.estoque}">

    <button type="submit">Registrar</button>

</form>

</body>
</html>
