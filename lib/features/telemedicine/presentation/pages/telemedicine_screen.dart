import 'package:flutter/material.dart';
import '../../../../theme/colors.dart';
import '../../../../theme/styles.dart';

class ChatMessage {
  final String sender;
  final String text;
  final String time;

  ChatMessage({required this.sender, required this.text, required this.time});
}

class TelemedicineScreen extends StatefulWidget {
  @override
  State<TelemedicineScreen> createState() => _TelemedicineScreenState();
}

class _TelemedicineScreenState extends State<TelemedicineScreen> {
  bool _isMicOn = true;
  bool _isVideoOn = true;
  bool _isScreenShare = false;

  final List<ChatMessage> _chatHistory = [
    ChatMessage(sender: "Patient (Marcus Vance)", text: "Hello doctor, can you hear me clearly?", time: "10:14 AM"),
    ChatMessage(sender: "Dr. Sarah Jenkins", text: "Yes Marcus, I can hear you fine. How are you feeling today?", time: "10:15 AM"),
    ChatMessage(sender: "Patient (Marcus Vance)", text: "Having slight tightness in chest since morning after taking the pills.", time: "10:16 AM"),
  ];

  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width <= 768;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Telemedicine Video Portal", style: AppStyles.titleMedium),
          Text("Active secure WebRTC link session with patient", style: AppStyles.bodySmall),
          const SizedBox(height: 16),

          LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth < 900) {
              return Column(
                children: [
                  _buildVideoFeed(isMobile),
                  const SizedBox(height: 16),
                  _buildChatPanel(),
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _buildVideoFeed(isMobile)),
                const SizedBox(width: 16),
                Expanded(flex: 2, child: _buildChatPanel()),
              ],
            );
          })
        ],
      ),
    );
  }

  Widget _buildVideoFeed(bool isMobile) {
    return Container(
      decoration: AppStyles.cardDecoration(color: AppColors.gray900),
      height: 320,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Main Video Viewport (Simulating remote patient view)
          Positioned.fill(
            child: Container(
              color: const Color(0xFF1B2638),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Marcus Vance (Patient Video Stream)",
                    style: AppStyles.bodySemibold.copyWith(color: Colors.white, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.lock, size: 12, color: AppColors.accentGreen),
                      SizedBox(width: 4),
                      Text("End-to-End Encrypted", style: TextStyle(color: AppColors.accentGreen, fontSize: 10)),
                    ],
                  )
                ],
              ),
            ),
          ),

          // Self PIP stream (Simulating local doctor camera)
          if (_isVideoOn)
            Positioned(
              right: 16,
              top: 16,
              child: Container(
                width: 90,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.gray800,
                  borderRadius: AppStyles.radiusMd,
                  border: Border.all(color: Colors.white.withOpacity(0.5)),
                  boxShadow: AppStyles.shadowSm,
                ),
                alignment: Alignment.center,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.medical_services, color: AppColors.accentGreen, size: 24),
                    SizedBox(height: 4),
                    Text("You (Dr. Jenkins)", style: TextStyle(color: Colors.white, fontSize: 8)),
                  ],
                ),
              ),
            ),

          // Media controls drawer (overlay)
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildControlButton(
                  icon: _isMicOn ? Icons.mic : Icons.mic_off,
                  color: _isMicOn ? AppColors.white : AppColors.accentRed,
                  iconColor: _isMicOn ? AppColors.gray800 : AppColors.white,
                  onTap: () => setState(() => _isMicOn = !_isMicOn),
                ),
                _buildControlButton(
                  icon: _isVideoOn ? Icons.videocam : Icons.videocam_off,
                  color: _isVideoOn ? AppColors.white : AppColors.accentRed,
                  iconColor: _isVideoOn ? AppColors.gray800 : AppColors.white,
                  onTap: () => setState(() => _isVideoOn = !_isVideoOn),
                ),
                _buildControlButton(
                  icon: _isScreenShare ? Icons.screen_share : Icons.stop_screen_share,
                  color: _isScreenShare ? AppColors.accentGreen : AppColors.white,
                  iconColor: _isScreenShare ? AppColors.white : AppColors.gray800,
                  onTap: () => setState(() => _isScreenShare = !_isScreenShare),
                ),
                const SizedBox(width: 20),
                _buildControlButton(
                  icon: Icons.call_end,
                  color: AppColors.accentRed,
                  iconColor: AppColors.white,
                  onTap: () {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(40),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 18),
        ),
      ),
    );
  }

  Widget _buildChatPanel() {
    return Container(
      height: 320,
      padding: const EdgeInsets.all(16.0),
      decoration: AppStyles.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Call Live Chat", style: AppStyles.titleSmall),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _chatHistory.length,
              itemBuilder: (context, index) {
                final msg = _chatHistory[index];
                bool isMe = msg.sender.startsWith("Dr.");
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      constraints: const BoxConstraints(maxWidth: 200.0),
                      decoration: BoxDecoration(
                        color: isMe ? AppColors.primaryBg : AppColors.gray100,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(8),
                          topRight: const Radius.circular(8),
                          bottomLeft: isMe ? const Radius.circular(8) : Radius.zero,
                          bottomRight: isMe ? Radius.zero : const Radius.circular(8),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(msg.sender, style: TextStyle(fontSize: 9, color: isMe ? AppColors.primary : AppColors.gray500, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text(msg.text, style: const TextStyle(fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // Chat input field
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: "Type note...",
                    hintStyle: TextStyle(fontSize: 12),
                    isDense: true,
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send, color: AppColors.primary, size: 20),
                onPressed: () {
                  if (_messageController.text.isNotEmpty) {
                    setState(() {
                      _chatHistory.add(ChatMessage(
                        sender: "Dr. Sarah Jenkins",
                        text: _messageController.text,
                        time: "Just now",
                      ));
                    });
                    _messageController.clear();
                  }
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
