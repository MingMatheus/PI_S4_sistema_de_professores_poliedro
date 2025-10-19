const express = require("express")
const router = express.Router()

const serieController = require("../controllers/serie.controller")
const authMiddleware = require("../../middlewares/auth.middleware")

// Rotas públicas

// Rotas protegidas

// Rotas restritas
router.post(
  "/",
  authMiddleware,
  checkRole(["professor"]),
  serieController.cadastraSerie
)

module.exports = router
