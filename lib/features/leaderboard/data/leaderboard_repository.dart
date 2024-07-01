import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardRepository {
  final FirebaseFirestore _firestore;

  LeaderboardRepository(this._firestore);

  Future<void> updateUserScore(String userID, int score) async {
    // Update user's score in their document
    await _firestore.collection('users').doc(userID).update({
      'score': score,
    });

    // Fetch the global leaderboard document
    DocumentReference globalLeaderboardRef = _firestore.collection('leaderboard').doc('global');
    DocumentSnapshot snapshot = await globalLeaderboardRef.get();
    
    if (snapshot.exists) {
      List userScores = snapshot['userScores'];
      bool userExists = false;

      // Check if user is already in the leaderboard
      for (var userScore in userScores) {
        if (userScore['userID'] == userID) {
          userScore['score'] = score;
          userExists = true;
          break;
        }
      }

      // If user does not exist in leaderboard, add them
      if (!userExists) {
        userScores.add({'userID': userID, 'score': score});
      }

      // Update the global leaderboard document
      await globalLeaderboardRef.update({
        'userScores': userScores,
      });
    } else {
      // If leaderboard document does not exist, create it
      await globalLeaderboardRef.set({
        'userScores': [{'userID': userID, 'score': score}],
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchGlobalLeaderboard() async {
    DocumentSnapshot snapshot = await _firestore.collection('leaderboard').doc('global').get();

    if (snapshot.exists) {
      List userScores = snapshot['userScores'];
      userScores.sort((a, b) => b['score'].compareTo(a['score'])); // Sort by score descending
      return List<Map<String, dynamic>>.from(userScores);
    }

    return [];
  }

  Future<List<Map<String, dynamic>>> fetchLocalLeaderboard(String userID) async {
    DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(userID).get();

    if (userSnapshot.exists) {
      List friends = userSnapshot['friends'];
      List<Map<String, dynamic>> localScores = [];

      for (String friendID in friends) {
        DocumentSnapshot friendSnapshot = await _firestore.collection('users').doc(friendID).get();
        if (friendSnapshot.exists) {
          localScores.add({
            'userID': friendID,
            'score': friendSnapshot['score'],
            'name': friendSnapshot['name'],
          });
        }
      }

      localScores.sort((a, b) => b['score'].compareTo(a['score'])); // Sort by score descending
      return localScores;
    }

    return [];
  }
}
