import { prisma } from "../application/database.js";
import { HttpException } from "../middleware/error.js";
import { hash, verify } from "argon2";
import jwt from "jsonwebtoken";
import "dotenv/config";

export const register = async (request) => {
  try {
    // Check if user already exists
    const existingUser = await prisma.users.findUnique({
      where: { username: request.username },
    });

    if (existingUser) {
      throw new HttpException(409, "User already exists");
    }

    // Hash the password
    const hashedPassword = await hash(request.password);

    // Create a new user
    const user = await prisma.users.create({
      data: {
        fullname: request.fullname,
        username: request.username,
        password: hashedPassword,
      },
      select: {
        id: true,
        fullname: true,
        username: true,
        created_at: true,
      },
    });

    return {
      message: "User created successfully",
      user,
    };
  } catch (error) {
    throw new HttpException(500, "Internal Server Error");
  }
};

export const login = async (request) => {
  try {
    // Find the user
    const user = await prisma.users.findUnique({
      where: { username: request.username },
    });

    if (!user) {
      throw new HttpException(401, "Invalid credentials");
    }

    // Verify password
    const isPasswordValid = await verify(user.password, request.password);
    if (!isPasswordValid) {
      throw new HttpException(401, "Invalid credentials");
    }

    // Generate JWT token
    const token = jwt.sign(
      { id: user.id },
      process.env.JWT_KEY,
      { expiresIn: '1h' } // Add an expiration for security
    );

    return {
      message: "Login successful",
      access_token: token,
    };
  } catch (error) {
    throw new HttpException(500, "Internal Server Error");
  }
};
