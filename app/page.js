"use client";

import Link from "next/link";
import { useAuth } from "../contexts/AuthContext";

export default function Home() {
  const { user } = useAuth();

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50">
      <div className="container mx-auto px-4 py-16">
        <div className="text-center max-w-4xl mx-auto">
          <h1 className="text-5xl md:text-6xl font-bold text-gray-900 mb-6">
            AI-Powered Learning
            <span className="block text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-purple-600">
              Management System
            </span>
          </h1>
          
          <p className="text-xl text-gray-600 mb-12 max-w-2xl mx-auto">
            Create personalized study materials, practice with interactive quizzes,
            and master your subjects with AI-generated content.
          </p>

          <div className="flex flex-col sm:flex-row gap-4 justify-center items-center mb-16">
            {user ? (
              <Link
                href="/dashboard"
                className="px-8 py-4 bg-blue-600 hover:bg-blue-700 text-white font-semibold rounded-lg shadow-lg transition duration-200 text-lg"
              >
                Go to Dashboard
              </Link>
            ) : (
              <>
                <Link
                  href="/register"
                  className="px-8 py-4 bg-blue-600 hover:bg-blue-700 text-white font-semibold rounded-lg shadow-lg transition duration-200 text-lg"
                >
                  Get Started
                </Link>
                <Link
                  href="/login"
                  className="px-8 py-4 bg-white hover:bg-gray-50 text-blue-600 font-semibold rounded-lg shadow-lg border-2 border-blue-600 transition duration-200 text-lg"
                >
                  Sign In
                </Link>
              </>
            )}
          </div>

          <div className="grid md:grid-cols-3 gap-8 mt-16">
            <div className="bg-white p-6 rounded-xl shadow-lg">
              <div className="text-4xl mb-4">📚</div>
              <h3 className="text-xl font-semibold mb-2">Study Materials</h3>
              <p className="text-gray-600">
                Access comprehensive notes and learning resources
              </p>
            </div>
            <div className="bg-white p-6 rounded-xl shadow-lg">
              <div className="text-4xl mb-4">🎯</div>
              <h3 className="text-xl font-semibold mb-2">Interactive Quizzes</h3>
              <p className="text-gray-600">
                Test your knowledge with gamified assessments
              </p>
            </div>
            <div className="bg-white p-6 rounded-xl shadow-lg">
              <div className="text-4xl mb-4">💡</div>
              <h3 className="text-xl font-semibold mb-2">Flashcards</h3>
              <p className="text-gray-600">
                Memorize key concepts with interactive flashcards
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
