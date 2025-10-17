const express = require("express")
const router = express.Router()

const authController = require("../controllers/auth.controller")

router.post("/registrar/aluno", authController.registraAluno)

module.exports = router
