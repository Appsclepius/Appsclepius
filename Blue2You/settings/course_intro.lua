LoremIpsum =
{
    Long = "Sed amet sed, pede id in neque diam in, varius et nulla, gravida habitant sem nisl. Purus vitae eget, tempus erat lacus libero platea, purus est suspendisse in tempus nam augue. Optio nisl in vivamus magna duis, arcu convallis, augue nostra pretium, tenetur dolor habitasse sodales vulputate, varius sit nulla non in nibh. Eros massa nisl vel sit quis, ullamcorper velit vivamus elit mauris, id et gravida id condimentum eget dui. Fermentum wisi turpis ut, sodales purus, nulla pellentesque, quam consequat ipsum vivamus. Sit pellentesque tincidunt mollis condimentum curabitur, nulla rhoncus suspendisse lorem sit justo. Morbi ut, odio praesent dictum phasellus velit vitae, nisl nisl magna fringilla volutpat convallis, gravida in suspendisse proin a mattis ac, morbi tincidunt vulputate ornare aenean integer integer. Fugit pharetra sed sociis eget, urna aliquet sodales nunc amet, diam litora fusce dolor in et quisque, inventore dolor vehicula a neque tortor sagittis. Ultrices sit eu eu nec, mauris orci sapien etiam rhoncus, odio dolor faucibus leo, eros dolor, quis sodales montes at sed ad. Non et est. Fringilla arcu, nec massa pellentesque quisque. Consequat tincidunt vestibulum, diam at euismod eget, auctor phasellus sapien ut parturient elit felis.",
    Long2P = "Lorem ipsum dolor sit amet, scelerisque wisi. Nec ac nonummy, vestibulum dolor velit laoreet risus scelerisque, dictum urna aliquam mattis curabitur rhoncus a. Tellus velit, libero a tempor libero, erat eget. Felis mattis scelerisque sed molestie dignissim. Quis risus, quis duis orci mollis eu ut, suscipit per ac at vitae. Purus suspendisse, duis erat duis in a lacinia ac, elementum aliquam vestibulum porta suspendisse porttitor vel, nibh litora. Neque magni cras, ante orci convallis eget eu facilisis, nec aliquet. Fringilla fermentum luctus justo lobortis in dapibus, duis eget lectus turpis venenatis eget, sollicitudin dolor et, rutrum donec vel mauris, nonummy quisque justo facilisis. Aliquet nunc aliquet velit pellentesque nec, ac felis lacus elit, vestibulum nostra sapien donec varius cras lacinia.\nPede cras curabitur eget mauris sem in, massa integer dis, non torquent purus vivamus purus lorem excepteur, facilisi magna varius nulla et ridiculus magna, quis at tempor eu ultrices. At lacus integer, quam vulputate erat nec, mi ornare, in sit odio duis. Parturient non felis est malesuada sollicitudin quisque, iaculis in ac sociis sit et, consectetuer pulvinar elementum, mus in, proin cum amet. Feugiat purus, aenean justo non ultrices egestas consequat, maecenas minim a risus ullamcorper, nulla magna felis, libero ullamcorper sollicitudin sit. Eros phasellus a velit consectetuer, ultrices quis elit tristique, erat libero ac dolor nec ac, ultrices bibendum fringilla maecenas mauris. Sit adipiscing lacinia elit nunc lobortis ipsum, aliqua nisl amet, dui suscipit lectus et suspendisse interdum, sit eu sed molestie fusce, metus tellus eros vestibulum sed necessitatibus. Nulla dignissim taciti in, nec nec vestibulum cursus, ac nulla commodo vel, metus vitae mi quam orci enim, dolor urna cursus tempor pulvinar vel. Rutrum dapibus massa imperdiet.",
    Short = "Bibendum orci libero magna ante, neque mauris sed quis enim, cras hymenaeos massa sapien, est sollicitudin eros, nullam quam arcu.",
    Short2 = "Rutrum dapibus massa imperdiet.",
}
Data =
{
    Name = 'Course 1: Intro',
    Desc = 'Show you the ropes of Blue2You.',
    TargetScreen = "ModuleGenericScreen",
    Settings = 
    {
        Elements =
        {
            AddImage( "images/welcome.png", 350, 233 ),
            AddText( "Welcome to Blue2You! We are so excited to start this great journey with you. We know that this journey may, at times, be hard, but together you can become great!" ),
            AddText( "Please take some time to look around at some of the games and other things we have available."),
            AddText( LoremIpsum.Long2P ),
            AddText( LoremIpsum.Long ),
        },
    },
}
