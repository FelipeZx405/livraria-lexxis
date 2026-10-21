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
            <th>Nome</th>
            <th>Options</th>
        </tr>
        <c:forEach var="livro" items="${livros}">
            <tr>
                <td>${livro.id}</td>
                <td>${livro.nome}</td>
                <td>
                     <form action="/delete-livro" method="post">
                         <input type= "hidden" id="id" name="id" value="${livro.id}">
                         <button type="submmit">Delete</button>
                         </form>
                         </td>
            </tr>
        </c:forEach>
    </table>
  </div>
</body>
</html>