const express = require("express")
const router = express.Router()

const turmaController = require("../controllers/turma.controller")
const authMiddleware = require("../../middlewares/auth.middleware")
const checkRole = require("../../middlewares/checkRole.middleware")

// Rotas públicas

// Rotas protegidas

// Rotas restritas
router.post(
  "/",
  authMiddleware,
  checkRole(["professor"]),
  turmaController.cadastraTurma
)

module.exports = router
