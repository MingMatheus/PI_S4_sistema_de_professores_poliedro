const {
  validaEmail,
  validaEmailAluno,
  validaEmailProfessor,
  validaSenha
} = require("../../../src/utils/validators.utils")

describe("Utils: validators", () => {
  // 1. Testa a função validaEmail
  describe("Função validaEmail", () => {
    // 1.1 Testa emails válidos
    it("Deve retornar true caso o email seja válido", () => {
      expect(validaEmail("a@b.c")).toBe(true)
      expect(validaEmail("email.de.teste@gmail.com")).toBe(true)
      expect(validaEmail("johsdjofhbsjhdbfkia@njbfsbidfbds.hboabsjhbjbajcb")).toBe(true)
      expect(validaEmail("usuario@email.com.br")).toBe(true)
    })

    // 1.2 Testa emails inválidos
    it("Deve retornar false caso o email seja inválido", () => {
      expect(validaEmail("meu.emailgmail.com")).toBe(false)
      expect(validaEmail("@gmail.com")).toBe(false)
      expect(validaEmail("joao@")).toBe(false)
      expect(validaEmail("email@gmailcom")).toBe(false)
      expect(validaEmail("joao@email.")).toBe(false)
    })

    // 1.3 Testa entradas inválidas (null, undefined, "")
    it("Deve retornar false caso a entrada seja inválida", () => {
      expect(validaEmail(null)).toBe(false)
      expect(validaEmail(undefined)).toBe(false)
      expect(validaEmail("")).toBe(false)
    })
  })

  // 2. Testa a função validaEmailAluno
  describe("Função validaEmailAluno", () => {
    // 1.1 Testa emails de aluno válidos
    it("Deve retornar true caso o email de aluno seja válido", () => {
      expect(validaEmailAluno("a@b.c")).toBe(true)
      expect(validaEmailAluno("email.de.teste@gmail.com")).toBe(true)
      expect(validaEmailAluno("johsdjofhbsjhdbfkia@njbfsbidfbds.hboabsjhbjbajcb")).toBe(true)
      expect(validaEmailAluno("usuario@email.com.br")).toBe(true)
      expect(validaEmailAluno("usuario@sistemapoliedro.combr")).toBe(true)
      expect(validaEmailAluno("usuario@sistemapoliedrocom.br")).toBe(true)
      expect(validaEmailAluno("usuario@sistema.poliedro.com.br")).toBe(true)
    })

    // 1.2 Testa emails de aluno inválidos
    it("Deve retornar false caso o email de aluno seja inválido", () => {
      expect(validaEmailAluno("meu.emailgmail.com")).toBe(false)
      expect(validaEmailAluno("@gmail.com")).toBe(false)
      expect(validaEmailAluno("joao@")).toBe(false)
      expect(validaEmailAluno("email@gmailcom")).toBe(false)
      expect(validaEmailAluno("joao@email.")).toBe(false)
      expect(validaEmailAluno("email@sistemapoliedro.com.br")).toBe(false)
      expect(validaEmailAluno("@sistemapoliedro.com.br")).toBe(false)
    })

    // 1.3 Testa entradas inválidas (null, undefined, "")
    it("Deve retornar false caso a entrada seja inválida", () => {
      expect(validaEmailAluno(null)).toBe(false)
      expect(validaEmailAluno(undefined)).toBe(false)
      expect(validaEmailAluno("")).toBe(false)
    })
  })

  // 3. Testa a função validaEmailProfessor
  describe("Função validaEmailProfessor", () => {
    // 1.1 Testa emails do professor válidos
    it("Deve retornar true caso o email do professor seja válido", () => {
      expect(validaEmailProfessor("abc@sistemapoliedro.com.br")).toBe(true)
      expect(validaEmailProfessor("y@sistemapoliedro.com.br")).toBe(true)
      expect(validaEmailProfessor("jose.pelegrino@sistemapoliedro.com.br")).toBe(true)
      expect(validaEmailProfessor("kjandhadkahdkhsadaç@sistemapoliedro.com.br")).toBe(true)
    })

    // 1.2 Testa emails do professor inválidos
    it("Deve retornar false caso o email do professor seja inválido", () => {
      expect(validaEmailProfessor("meu.emailsistemapoliedro.com.br")).toBe(false)
      expect(validaEmailProfessor("@gmail.com")).toBe(false)
      expect(validaEmailProfessor("joao@")).toBe(false)
      expect(validaEmailProfessor("email@gmailcom")).toBe(false)
      expect(validaEmailProfessor("joao@email.")).toBe(false)
      expect(validaEmailProfessor("@sistemapoliedro.com.br")).toBe(false)
      expect(validaEmailProfessor("a@b.c")).toBe(false)
      expect(validaEmailProfessor("email.de.teste@gmail.com")).toBe(false)
      expect(validaEmailProfessor("johsdjofhbsjhdbfkia@njbfsbidfbds.hboabsjhbjbajcb")).toBe(false)
      expect(validaEmailProfessor("usuario@email.com.br")).toBe(false)
      expect(validaEmailProfessor("usuario@sistemapoliedro.combr")).toBe(false)
      expect(validaEmailProfessor("usuario@sistemapoliedrocom.br")).toBe(false)
      expect(validaEmailProfessor("usuario@sistema.poliedro.com.br")).toBe(false)
    })

    // 1.3 Testa entradas inválidas (null, undefined, "")
    it("Deve retornar false caso a entrada seja inválida", () => {
      expect(validaEmailProfessor(null)).toBe(false)
      expect(validaEmailProfessor(undefined)).toBe(false)
      expect(validaEmailProfessor("")).toBe(false)
    })
  })

  // 4. Testa a função validaSenha
  describe("Função validaSenha", () => {
    // 1.1 Testa senhas válidas
    it("Deve retornar true caso a senha seja válida", () => {
      expect(validaSenha("12345678")).toBe(true)
      expect(validaSenha("1234567811911159")).toBe(true)
      expect(validaSenha("ugusagdjhagduhabdadbabdabdbsa")).toBe(true)
      expect(validaSenha("abcdabcd")).toBe(true)
    })

    // 1.2 Testa senhas inválidas
    it("Deve retornar false caso a senha seja inválida", () => {
      expect(validaSenha("1234567")).toBe(false)
      expect(validaSenha("121212")).toBe(false)
      expect(validaSenha("aaaaaa")).toBe(false)
      expect(validaSenha("a")).toBe(false)
    })

    // 1.3 Testa entradas inválidas (null, undefined, "")
    it("Deve retornar false caso a entrada seja inválida", () => {
      expect(validaSenha(null)).toBe(false)
      expect(validaSenha(undefined)).toBe(false)
      expect(validaSenha("")).toBe(false)
    })
  })
})
