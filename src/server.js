require("dotenv").config();

const express = require("express");
const helmet = require("helmet");
const cors = require("cors");
const rateLimit = require("express-rate-limit");

const hospitalRoutes = require("./routes/hospitalRoutes");
const serviceRoutes = require("./routes/serviceRoutes");
const comparisonRoutes = require("./routes/comparisonRoutes");
const hospitalServiceRoutes = require("./routes/hospitalServiceRoutes");
const authRoutes = require("./routes/authRoutes");
const profileRoutes = require("./routes/profileRoutes");
const reviewRoutes = require("./routes/reviewRoutes");
const errorMiddleware = require("./middleware/errorMiddleware");

const app = express();

const apiLimiter = rateLimit({
    windowMs: 15 * 60 * 1000,
    max: 100,
    message: {
        message: "Too many requests, please try again later."
    }
});

app.use(express.json({ limit: "10kb" }));
app.use(helmet());
app.use(cors());
app.use("/api", apiLimiter);


const PORT = process.env.PORT || 3000;

app.get("/", (req, res) => {
    res.send("Hospital Service Comparison API");
});

app.use("/api/hospitals", hospitalRoutes);
app.use("/api/services", serviceRoutes);
app.use("/api/comparisons", comparisonRoutes);
app.use("/api/hospital-services", hospitalServiceRoutes);
app.use("/api/auth", authRoutes);
app.use("/api/profile", profileRoutes);
app.use("/api/reviews", reviewRoutes);

app.use(errorMiddleware);

app.listen(PORT, () => {
    console.log(`Server running on address http://localhost:${PORT}`);
});