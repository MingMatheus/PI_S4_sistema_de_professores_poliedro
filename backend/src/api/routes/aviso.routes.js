const express = require("express")
const router = express.Router()

const avisoController = require("../controllers/aviso.controller")
const authMiddleware = require("../../middlewares/auth.middleware")
const checkRole = require("../../middlewares/checkRole.middleware")

const {
  ROLES
} = require("../../constants/validation.constants")

// Rotas públicas

// Rotas protegidas

// Rotas restritas
router.post(
  "/",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  avisoController.createAviso
)

module.exports = router
