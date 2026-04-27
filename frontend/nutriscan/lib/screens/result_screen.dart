import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  const ResultScreen({required this.result});

  Color getScoreColor(int score) {
    if (score > 70) return Colors.green;
    if (score > 40) return Colors.orange;
    return Colors.red;
  }

  Color getStatusColor(String status) {
    if (status == "good") return Colors.green;
    if (status == "bad") return Colors.red;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    final score = (result["health_score"] as num).toInt();
    final ingredients = result["ingredients"] ?? [];
    final badIngredients =
        ingredients.where((i) => i["status"] == "bad").toList();

    final claims = result["claims_analysis"] ?? [];

    return Scaffold(
      backgroundColor: Color(0xFFF5F7F6),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 50, bottom: 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  getScoreColor(score).withOpacity(0.8),
                  getScoreColor(score),
                ],
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Text(
                  "$score",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Health Score",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (badIngredients.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Why score is low",
                            style: TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          ...badIngredients.map<Widget>((i) => Text(
                                "• ${i["name"]}",
                                style: TextStyle(color: Colors.red),
                              )),
                        ],
                      ),
                    ),

                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(result["summary"] ?? ""),
                    ),
                  ),

                  SizedBox(height: 20),

                  if (claims.isNotEmpty) ...[
                    Text(
                      "Claims vs Reality",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),

                    ...claims.map<Widget>((c) {
                      Color verdictColor =
                          c["verdict"] == "true"
                              ? Colors.green
                              : Colors.red;

                      return Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: verdictColor.withOpacity(0.3)),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            c["claim"],
                            style: TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(c["truth"]),
                          trailing: Text(
                            c["verdict"],
                            style: TextStyle(
                              color: verdictColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),

                    SizedBox(height: 20),
                  ],

                  Text(
                    "Ingredient Analysis",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  SizedBox(height: 10),

                  ...ingredients.map<Widget>((item) {
                    final color = getStatusColor(item["status"]);

                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: color.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.circle, size: 10, color: color),
                          SizedBox(width: 10),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["name"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  item["reason"],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Text(
                            item["status"],
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  SizedBox(height: 20),
                  Text(
                    "Better Alternatives",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    children: List.generate(
                      result["alternatives"].length,
                      (index) => Chip(
                        label: Text(result["alternatives"][index]),
                        backgroundColor: Colors.green.shade100,
                      ),
                    ),
                  ),

                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}