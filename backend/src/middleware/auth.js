import { HttpException } from "./error.js";
import jwt from "jsonwebtoken";
import "dotenv/config";
export const authHander = (req, res, next) => {
try {
const token = req.headers.authorization?.substring(7);
if (!token) {
throw new HttpException(401, "Unauthorized");
}
jwt.verify(token, process.env.JWT_KEY, (err, user) => {
if (err) {
throw new HttpException(401, "Unauthorized");
}
req.user = user;
next();
});
} catch (error) {
next(error);
}
};