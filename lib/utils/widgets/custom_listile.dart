import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;
  final VoidCallback? deleteOnPressed;
  final bool isTutor;
  final int index;
  final int canTakeLessonIndex;

  const CustomListTile({
    super.key,
    required this.title,
    required this.onTap,
    required this.index,
    required this.canTakeLessonIndex,
    this.isTutor = false,
    this.deleteOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return isTutor
        ? () {
            return title == null
                ? const SizedBox.shrink()
                : InkWell(
                    onTap: onTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: deleteOnPressed,
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                        ],
                      ),
                    ),
                  );
          }()
        : () {
            return title == null
                ? const SizedBox.shrink()
                : InkWell(
                    onTap: index <= canTakeLessonIndex ? onTap : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: index <= canTakeLessonIndex
                            ? Colors.white
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  );
          }();
  }
}
