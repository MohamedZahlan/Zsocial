import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_app/models/comment_model.dart';

import '../../layout/social_app/cubit/cubit.dart';
import '../../layout/social_app/cubit/states.dart';
import '../../shared/network/shared.styles/colors.dart';
import '../../shared/shared_components/components.dart';

class CommentsScreen extends StatelessWidget {
  CommentsScreen({Key? key}) : super(key: key);

  final commentController = TextEditingController();
  final date = DateTime.now();
  //var formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is SocialCommentPostSuccessState) {
          showToast(msg: "Done", state: ToastStates.SUCCESS);
        }
      },
      builder: (context, state) {
        SocialCubit cubit = SocialCubit.get(context);
        var userModel = SocialCubit.get(context).userModel;
        var commentModel = SocialCubit.get(context).allComments;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                )),
            title: Row(
              children: [
                // first row for like icon and number of likes
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 20,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 80,
                          ),
                          Text(
                            "1",
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.comment,
                            color: Colors.grey,
                            size: 20,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 80,
                          ),
                          Text(
                            "${commentModel.length} comments",
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: screenHeight(context) / 1.34,
                    child: ListView.separated(
                      //reverse: true,
                      shrinkWrap: false,
                      //physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => buildCommentItem(
                        context,
                        userModel,
                        commentModel[index],
                      ),
                      separatorBuilder: (context, index) => SizedBox(
                        height: screenHeight(context) / 40,
                      ),
                      itemCount: commentModel.length,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2, top: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // this method for add photo in the post
                        IconButton(
                            onPressed: () {
                              cubit.getCommentImageFromCamera();
                            },
                            icon: Icon(
                              Icons.camera_alt_outlined,
                              color: myDefaultColor,
                              size: 25,
                            )),
                        IconButton(
                            onPressed: () {
                              cubit.getCommentImageFromGallery();
                            },
                            icon: Icon(
                              Icons.photo_library_outlined,
                              color: myDefaultColor,
                              size: 25,
                            )),
                        // this method for divider
                        Container(
                          height: MediaQuery.of(context).size.height / 13,
                          width: 2,
                          color: Colors.grey.shade300,
                        ),
                        // for spacing
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 40,
                        ),
                        // this method for TextFormField && Choose photos
                        Expanded(
                          child: TextFormField(
                            cursorColor: myDefaultColor,
                            controller: commentController,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              fillColor: myDefaultColor,
                              hoverColor: myDefaultColor,
                              iconColor: myDefaultColor,
                              hintText: "Write a comment",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    if (cubit.commentImage != null) {
                                      cubit.createCommentWithImage(
                                        text: commentController.text,
                                        date: date.toString(),
                                      );
                                      commentController.clear();
                                    } else {
                                      cubit.createComment(
                                        text: commentController.text,
                                        date: date.toString(),
                                      );
                                      commentController.clear();
                                    }
                                  },
                                  icon: Icon(
                                    Icons.send,
                                    color: myDefaultColor,
                                  )),
                              focusColor: myDefaultColor,
                              suffixIconColor: myDefaultColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildCommentItem(context, userModel, CommentModel commentModel) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider("${userModel!.image}"),
                radius: 25,
              ),
              // for spacing
              SizedBox(
                width: MediaQuery.of(context).size.width / 30,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 15.0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // this method for username
                      Text(
                        "${userModel.name}",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      // this method for comment text
                      Text(
                        "${commentModel.text}",
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                      // this method for comment image
                      // if (commentModel.commentImage != null)
                      //   FullScreenWidget(
                      //     child: Hero(
                      //       tag: 'hero12',
                      //       child: Container(
                      //         height: screenHeight(context) / 4,
                      //         width: double.infinity,
                      //         decoration: BoxDecoration(
                      //           image: DecorationImage(
                      //             // fit: BoxFit.cover,
                      //             image: CachedNetworkImageProvider(
                      //                 '${commentModel.commentImage}'),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // if (commentModel.commentImage == null)
                      //   SizedBox(
                      //     height: screenHeight(context) / 80,
                      //   ),
                      // this method for comment date
                      Text(
                        "10/3/2020",
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
              ),
              // this method for space between username and IconButton
              SizedBox(
                width: MediaQuery.of(context).size.width / 80,
              ),
              // this method for IconButton More
              IconButton(
                onPressed: () {},
                alignment: AlignmentDirectional.topStart,
                icon: const Icon(
                  Icons.more_vert,
                ),
              ),
            ],
          ),
        ],
      );
}
