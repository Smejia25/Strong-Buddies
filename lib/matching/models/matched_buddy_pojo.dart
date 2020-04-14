class MatchedBuddy {
  String displayName;  
  String photoUrl;

  MatchedBuddy({this.displayName, this.photoUrl});

  MatchedBuddy.fromJson(Map<String, dynamic> json) {
    displayName = json['displayName'];    
    photoUrl = json['photoUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['displayName'] = this.displayName;    
    data['photoUrl'] = this.photoUrl;
    return data;
  }
}
