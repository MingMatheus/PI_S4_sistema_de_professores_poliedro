const express = require("express")
const router = express.Router()

const serieController = require("../controllers/serie.controller")

router.post("/", serieController.cadastraSerie)

module.exports = router
