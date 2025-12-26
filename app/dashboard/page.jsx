import React from 'react'
import WelcomeBanner from './_components/WelcomeBanner'
import CourseList from './_components/CourseList'

export const dynamic = 'force-dynamic';

function Dashboard() {
  return (
    <div>
        <WelcomeBanner/>
        <CourseList/>
    </div>
  )
}

export default Dashboard