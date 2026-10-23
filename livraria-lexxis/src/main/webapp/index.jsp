<html>
<body>
<h2>Livraria Lexxis</h2>

<form action="/create-livro" method="post">

    <label>Nome do Livro:</label>
    <input type="text" name="name" id="id"  value="${param.name}">
    <input type="hidden" id="id" name="id" value="${param.id}">

    <button type="submit">Registrar</button>

</form>

</body>
</html>
