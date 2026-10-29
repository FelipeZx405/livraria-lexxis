<!DOCTYPE html>
<html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>
</head>
<body>
  <div>
    <h1>Livros</h1>
    <table>
       <tr>
           <th>ID</th>
           <th>Name</th>
           <th>Autor</th>
           <th>Descricao</th>
           <th>Preco</th>
           <th>Estoque</th>
           <th>Options</th>
       </tr>
        <c:forEach var="livro" items="${livros}">
            <tr>
                <td>${livro.id}</td>
                <td>${livro.nome}</td>
                <td>${livro.autor}</td>
                <td>${livro.descricao}</td>
                <td>${livro.preco}</td>
                <td>${livro.estoque}</td>
                <td>
                     <form action="/delete-livro" method="post">
                         <input type= "hidden" id="id" name="id" value="${livro.id}">
                         <button type="submit">Delete</button>
                         <span> | </span>
                         <a href="index.jsp?id=${livro.id}&name=${livro.nome}&autor=${livro.autor}&descricao=${livro.descricao}&preco=${livro.preco}&estoque=${livro.estoque}">Update</a>
                         </form>
                         </td>
            </tr>
        </c:forEach>
    </table>
  </div>
</body>
</html>