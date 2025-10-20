const express = require("express")
const router = express.Router()

const authController = require("../controllers/auth.controller")
const authMiddleware = require("../../middlewares/auth.middleware")
const checkRole = require("../../middlewares/checkRole.middleware")

const {
  ROLES
} = require("../../constants/validation.constants")

// Rotas públicas
router.post("/login", authController.login)

// Rotas protegidas

// Rotas restritas
router.post(
  "/cadastro/alunos",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  authController.cadastraAluno
)
router.post(
  "/cadastro/professores",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  authController.cadastraProfessor
)

module.exports = router
