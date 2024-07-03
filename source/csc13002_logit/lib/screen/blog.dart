import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:logit/model/article.dart';
import 'package:logit/widget/bookmark.dart';
import 'package:logit/widget/discovery.dart';

class HealthBlog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Health Blog',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.account_circle_rounded,
                      size: 45,
                    ),
                    onPressed: () {
                      // Handle button press
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.search),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for articles, titles, etc.',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              child: Text(
                'Bookmarked',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 210,
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: bookmarkedArticles.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: BookmarkCard(bookmarkedArticles[index]),
                      );
                    },
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              child: Text(
                'Discovery',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: bookmarkedArticles.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    child: DiscoveryCard(bookmarkedArticles[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const GNav(
        gap: 4,
        color: Color.fromARGB(255, 75, 153, 78),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        activeColor: Color.fromARGB(255, 203, 26, 13),
        tabs: [
          GButton(icon: Icons.home, text: 'Home'),
          GButton(icon: Icons.health_and_safety, text: 'Health Diary'),
          GButton(icon: Icons.notifications_on, text: 'Notifications'),
          GButton(icon: Icons.event_note_rounded, text: 'Reminders')
        ],
      ),
    );
  }
}
