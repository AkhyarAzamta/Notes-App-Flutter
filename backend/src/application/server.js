import express from "express";
import cors from "cors";
import { errorHandler } from "../middleware/error.js";
import { router } from "../route/api.js";
export const app = express();
app.use(cors());
app.use(express.json());
app.get("/", (req, res) => {
res.status(200).json({ message: "Hello World!" });
});
app.use(router);
app.use(errorHandler);