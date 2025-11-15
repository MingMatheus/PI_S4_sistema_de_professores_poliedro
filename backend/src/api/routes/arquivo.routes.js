const express = require("express")
const router = express.Router()
const multer = require('multer');

const multerConfig = require("../../config/multer.config");

const arquivoController = require("../controllers/arquivo.controller")
const authMiddleware = require("../../middlewares/auth.middleware")
const checkRole = require("../../middlewares/checkRole.middleware")

const {
  ROLES
} = require("../../constants/validation.constants")

// Rotas públicas

// Rotas protegidas
router.get(
  "/",
  authMiddleware,
  arquivoController.getTodosArquivos
)

router.get(
  "/:id",
  authMiddleware,
  arquivoController.getArquivoById
)

// Rotas restritas
router.post(
  "/",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  multer(multerConfig).single("arquivo"),
  arquivoController.createArquivo
)

router.put(
  "/:id",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  arquivoController.updateArquivoById
)

router.delete(
  "/:id",
  authMiddleware,
  checkRole([ROLES.PROFESSOR]),
  arquivoController.deleteArquivoById
)

module.exports = router
