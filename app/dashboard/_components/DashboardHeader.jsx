"use client";

import { useAuth } from '../../../contexts/AuthContext';
import React from 'react';

function DashboardHeader() {
  const { user, logout } = useAuth();

  return (
    <div className='p-5 shadow-md flex justify-between items-center'>
      <div className='text-lg font-semibold text-gray-800'>
        AI-LMS Dashboard
      </div>
      <div className='flex items-center gap-4'>
        {user && (
          <>
            <div className='text-sm text-gray-600'>
              Welcome, <span className='font-semibold'>{user.name}</span>
            </div>
            <button
              onClick={logout}
              className='px-4 py-2 bg-red-500 hover:bg-red-600 text-white rounded-lg text-sm font-medium transition'
            >
              Logout
            </button>
          </>
        )}
      </div>
    </div>
  );
}

export default DashboardHeader;