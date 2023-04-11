CREATE DATABASE prova;

-- Questão 01 
CREATE TABLE Clientes (
  ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  Nome VARCHAR(50) NOT NULL, 
  Sobrenome VARCHAR(50) NOT NULL,
  CPF VARCHAR(11) NOT NULL UNIQUE CHECK (CPF <> '00000000000')
)

-- Questão 01 
CREATE TABLE Pedidos (
  ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  ClienteID INT FOREIGN KEY REFERENCES Clientes(ID),
  Produto VARCHAR(50) NOT NULL,
  Quantidade INT NOT NULL CHECK (Quantidade > 0),
)
-- Questão 02 
USE [prova]
GO
INSERT INTO [dbo].[Clientes] ([Nome],[Sobrenome],[CPF]) VALUES ('João', 'Silva', '12345678900')
INSERT INTO [dbo].[Clientes] ([Nome],[Sobrenome],[CPF]) VALUES ('Maria', 'Souza', '98765432100')
INSERT INTO [dbo].[Clientes] ([Nome],[Sobrenome],[CPF]) VALUES ('Pedro', 'Santos', '45678912300')
INSERT INTO [dbo].[Clientes] ([Nome],[Sobrenome],[CPF]) VALUES ('Lucas', 'Ferreira', '32165498700')
INSERT INTO [dbo].[Clientes] ([Nome],[Sobrenome],[CPF]) VALUES ('Ana', 'Oliveira', '78912345600')
GO
-- Questão 02 
USE [prova]
GO
INSERT INTO [dbo].[Pedidos] ([ClienteID],[Produto],[Quantidade]) VALUES (1, 'Camiseta', 2)
INSERT INTO [dbo].[Pedidos] ([ClienteID],[Produto],[Quantidade]) VALUES (1, 'Calça', 12)
INSERT INTO [dbo].[Pedidos] ([ClienteID],[Produto],[Quantidade]) VALUES (2, 'Sapato', 2)
INSERT INTO [dbo].[Pedidos] ([ClienteID],[Produto],[Quantidade]) VALUES (2, 'Camisa', 1)
INSERT INTO [dbo].[Pedidos] ([ClienteID],[Produto],[Quantidade]) VALUES (2, 'Bermuda', 3)
GO
-- Questão 03 
CREATE PROCEDURE InserirClientesPedidos
    @nome VARCHAR(50),
    @sobrenome VARCHAR(50),
    @cpf VARCHAR(14),
    @produto VARCHAR(50),
    @quantidade INT
AS
BEGIN
    INSERT INTO Clientes (Nome, Sobrenome, CPF) VALUES (@nome, @sobrenome, @cpf);
    DECLARE @cliente_id INT = @@IDENTITY;
    INSERT INTO Pedidos (ClienteID, Produto, Quantidade) VALUES (@cliente_id, @produto, @quantidade);
END;

EXECUTE InserirClientesPedidos 'João', 'Silva', '12345678901', 'Camiseta', 2;
-- Questão 04
CREATE VIEW BuscarIdView
AS
SELECT c.ID as ClienteID, c.Nome as ClienteNome, p.ID as PedidoID, p.Produto as PedidoProduto
FROM Clientes c
JOIN Pedidos p ON c.ID = p.ClienteID;

SELECT * FROM BuscarIdView;
-- Questão 05
CREATE FUNCTION ContarLinhasClientes()
RETURNS INT
AS
BEGIN
    DECLARE @RowCount INT;
    SELECT @RowCount = COUNT(*) FROM Clientes;
    RETURN @RowCount;
END;
SELECT dbo.ContarLinhasClientes();
-- Questão 06
CREATE TABLE Clientes_Audit (
    ID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nome VARCHAR(50),
    Sobrenome VARCHAR(50),
    CPF VARCHAR(11),
    DataInclusao DATETIME
);


CREATE TRIGGER ClientesInsertTrigger
ON Clientes
AFTER INSERT
AS
BEGIN
    INSERT INTO Clientes_Audit (Nome, Sobrenome, CPF, DataInclusao)
    SELECT Nome, Sobrenome, CPF, GETDATE() FROM inserted;
END;
